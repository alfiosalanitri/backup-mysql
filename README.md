# NAME
backup-mysql.sh - create a tar archive with databases stored in .sql.gz separated file.

# DESCRIPTION
this script dump all databases into singular database.sql.gz file and create an archive .tar.xz into current script directory.

# INSTALLATION
- `sudo chown root: /path/to/backup-mysql.sh`
- `sudo chown root: /path/to/.backup-mysql-config`
- `sudo chmod 600 /path/to/.backup-mysql-config`
- `sudo chmod +x /path/to/backup-mysql.sh`

# USAGE
`./backup-mysql.sh /path/to/.backup-mysql`

# HOW TO restore a single database?
`zcat database.sql.gz | mysql -u username -p database_name`
       
# AUTHOR: 
backup-mysql.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the MIT License.
