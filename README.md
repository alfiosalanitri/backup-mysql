# NAME
backup-mysql - create a tar archive with databases stored in .sql.gz separated file.

# DESCRIPTION
this script dump all databases into singular database.sql.gz file and create an archive .tar.xz into current script directory.

# INSTALLATION
- rename .config.example to .config
- edit .config file with your data
- `sudo chown root:root /path/to/backup-mysql`
- `sudo chown root:root /path/to/.config`
- `sudo chmod 600 /path/to/.config`
- `sudo chmod +x /path/to/backup-mysql`

# USAGE
`./backup-mysql /path/to/.config /path/to/backup/destination`

# HOW TO restore a singular database?
`zcat database.sql.gz | mysql -u username -p database_name`
       
# AUTHOR: 
backup-mysql is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the MIT License.
