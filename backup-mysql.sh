#! /bin/bash
#
# NAME
# 	backup-mysql.sh - Export all database in singular database_name.sql.gz file and archive all in a tar.xz archive.
#
# SYNOPSIS
#	./backup-mysql.sh username password
#
# DESCRIPTION
#	this script dump all databases into singular database.sql.gz file and create an archive .tar.xz into current script directory.
#   NOTE: pass the database password to this script isn't safety. Create a database user with this privileges: SHOW DATABASES, SELECT, LOCK TABLES, RELOAD, SHOW VIEW and use it.
#
# INSTALLATION
#	sudo chmod +x backup-mysql.sh
#	
# AUTHOR: 
#	backup-mysql.sh is written by Alfio Salanitri <www.alfiosalanitri.it> and are licensed under the terms of the GNU General Public License, version 2 or higher.
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
TIMESTAMP=$(date +"%d%m%Y-%H%M")
CURRENT_DIR=$(pwd)
BACKUP_DIR="/tmp/backup-mysql"
if [ ! "$1" ]; then
    printf "[${red}${icon_ko}${nocolor}] Type the database user\n"
    exit 1
fi
if [ ! "$2" ]; then
    printf "[${red}${icon_ko}${nocolor}] Type the database password\n"
    exit 1
fi
MYSQL_USER=$1
MYSQL_PASSWORD=$2
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
# Check packages
if ! command -v $MYSQL &> /dev/null; then
	printf "${red}${icon_ko}${nocolor} Sorry, but ${green}mysql${nocolor} is required.\n"
	exit 1
fi
if ! command -v $MYSQLDUMP &> /dev/null; then
	printf "${red}${icon_ko}${nocolor} Sorry, but ${green}mysqldump${nocolor} is required.\n"
	exit 1
fi

SECONDS=0

# create the backup tmp dir
mkdir -p $BACKUP_DIR

printf "[${yellow}${icon_wait}${nocolor}] Reading all databases...\n\n"
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
 
for db in $databases; do
	printf "[${yellow}${icon_wait}${nocolor}] Saving database: ${green}${db}${nocolor}...\n"
	$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$db.sql.gz"
	db_size=$(stat -c %s "$BACKUP_DIR/$db.sql.gz" | numfmt --to=iec)
	printf "[${green}${icon_ok}${nocolor}] Database: ${green}${db} ($db_size)${nocolor} saved!\n"
	echo "--------------------------"
done

printf "\n[${yellow}${icon_wait}${nocolor}] Compressing directory...\n"
tar cJfP $CURRENT_DIR/mysqldump-databases-$TIMESTAMP.tar.xz $BACKUP_DIR
printf "[${green}${icon_ok}${nocolor}] Archive stored into current directory.\n"
rm -r $BACKUP_DIR
printf "[${green}${icon_ok}${nocolor}] Temporary directory deleted.\n\n"
duration=$SECONDS
printf "Backup date: $(date)\n"
printf "Backup time elapsed: $(($duration / 60)) minutes and $(($duration % 60)) seconds.\n"
exit 1
