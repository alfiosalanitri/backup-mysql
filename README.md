# NAME
backup-mysql.sh - create a tar archive with databases stored in .sql.gz separated file.

# DESCRIPTION
this script dump all databases into singular database.sql.gz file and create an archive .tar.xz into current script directory.
NOTE: pass the database password to this script isn't safety. Create a database user with this privileges: SHOW DATABASES, SELECT, LOCK TABLES, RELOAD, SHOW VIEW and use it.
	

# INSTALLATION
`sudo chmod +x backup-mysql.sh`


# USAGE
`./backup-mysql.sh username password`
       
# AUTHOR: 
backup-mysql.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the terms of the GNU General Public License, version 2 or higher. 
