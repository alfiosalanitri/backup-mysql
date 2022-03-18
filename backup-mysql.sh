#! /bin/bash
#
# NAME
# backup-mysql.sh - create a tar archive with databases stored in .sql.gz separated file.
#
# SYNOPSIS
#	./backup-mysql.sh /path/to/.config /path/to/backup/destination
#
# DESCRIPTION
#	this script dump all databases into singular database.sql.gz file and create an archive .tar.xz into current script directory.
#
# INSTALLATION
# - rename .config.example to .config
# - edit .config file with your data
# - sudo chown root:root /path/to/backup-mysql.sh
# - sudo chown root:root /path/to/.config
# - sudo chmod 600 /path/to/.config
#	- sudo chmod +x /path/to/backup-mysql.sh
#
# AUTHOR:
#	backup-mysql.sh is written by Alfio Salanitri <www.alfiosalanitri.it> and are licensed under the MIT License.
#
#
#############################################################
# Icons	and color
# https://www.techpaste.com/2012/11/print-colored-text-background-shell-script-linux/
# https://apps.timwhitlock.info/emoji/tables/unicode
#############################################################
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
nocolor='\033[0m'
icon_ok='\xE2\x9C\x94'
icon_ko='\xe2\x9c\x97'
icon_wait='\xE2\x8C\x9B'

#############################################################
# VARIABLES
#############################################################
if [ ! -f "$1" ]; then
  printf "Sorry but the config file is required. \n"
  exit 1
fi
if [ ! -d "$2" ]; then
  printf "Sorry but the backup destination directory is required. \n"
  exit 1
fi
TIMESTAMP=$(date +"%d%m%Y-%H%M")
BACKUP_TMP_DIR="/tmp/backup-mysql"
MYSQL_USER=$(awk -F'=' '/^DATABASE_NAME=/ { print $2}' $1)
MYSQL_PASSWORD=$(awk -F'=' '/^DATABASE_PASSWORD=/ { print $2}' $1)
BACKUP_DESTINATION=${2%/}
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
if [ "" == "$MYSQL_USER" ]; then
  printf "[${red}${icon_ko}${nocolor}] Save the database user into config file\n"
  exit 1
fi
if [ "" == "$MYSQL_PASSWORD" ]; then
  printf "[${red}${icon_ko}${nocolor}] Save the database password into config file\n"
  exit 1
fi
# Check packages
if ! command -v $MYSQL &>/dev/null; then
  printf "${red}${icon_ko}${nocolor} Sorry, but ${green}mysql${nocolor} is required.\n"
  exit 1
fi
if ! command -v $MYSQLDUMP &>/dev/null; then
  printf "${red}${icon_ko}${nocolor} Sorry, but ${green}mysqldump${nocolor} is required.\n"
  exit 1
fi

SECONDS=0

# create the backup tmp dir
mkdir -p $BACKUP_TMP_DIR

printf "[${yellow}${icon_wait}${nocolor}] Reading all databases...\n\n"
databases=$($MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")

for db in $databases; do
  printf "[${yellow}${icon_wait}${nocolor}] Saving database: ${green}${db}${nocolor}...\n"
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >"$BACKUP_TMP_DIR/$db.sql.gz"
  db_size=$(stat -c %s "$BACKUP_TMP_DIR/$db.sql.gz" | numfmt --to=iec)
  printf "[${green}${icon_ok}${nocolor}] Database: ${green}${db} ($db_size)${nocolor} saved!\n"
  echo "--------------------------"
done

printf "\n[${yellow}${icon_wait}${nocolor}] Compressing directory...\n"
tar cJfP $BACKUP_DESTINATION/mysqldump-databases-$TIMESTAMP.tar.xz $BACKUP_TMP_DIR
printf "[${green}${icon_ok}${nocolor}] Archive stored to $BACKUP_DESTINATION directory.\n"
rm -r $BACKUP_TMP_DIR
printf "[${green}${icon_ok}${nocolor}] Temporary directory deleted.\n\n"
duration=$SECONDS
printf "Backup date: $(date)\n"
printf "Backup time elapsed: $(($duration / 60)) minutes and $(($duration % 60)) seconds.\n"
exit 1
