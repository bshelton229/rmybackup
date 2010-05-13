# RMyBackup

RMyBackup was created to solve a simple problem I had, and is hopefully useful to somebody else out there. RMyBackup is a quick way to backup up specified mysql databases using mysqldump. It writes a gzipped .sql file using a date/time naming convention to a specified directory.

### To Install
    # gem install rmybackup
    
## Usage

The gem will install an rmybackup binary. RMyBackup will read its configuration from ~/.rmybackup.conf or /etc/rmybackup.conf (a sample configuration file is shown below). The .rmybackup.conf file in your home folder will be used if present, next it rmybackup will look for /etc/rmybackup. You may also specify an alternate config file on the command line using rmybackup --config-file /alternate/config/file. RMyBackup will backup the specified databases in the databases: [] list in the configuration file.

To generate a sample config file, use the --instal-config option. Default location is /etc/rmybackup.conf, or if we can't write to /etc, ~/.rmybacukp.conf.

    # rmybackup --install-config [/config/location]

Right now the script relies on your [mysqldump] configuration in either /etc/my.cnf or the user's ~/.my.cnf. I'm hoping to change this soon, allowing you to specify the host, user, password, and socket in the configuration file.

    # example my.cnf
    
    [mysqldump]
    user = root
    password = roots_password
    

Once everything is set up correctly in the config file, and mysqldump is able to operate using credentials specified in the appropriate my.cnf file, you should simply be able to run the rmybackup command.

    # rmybackup


## Sample Configuration File

The default location for the configuration file is /etc/rmybackup.conf then ~/.rmybacukp.conf, it's formatted in YAML. You can specify a different config file on the command line using the --config-file (-f) option.

    backup_dir: /Users/username/mysql_backups/
    #Number of days to keep backups
    remove_after: 7

    #Databases to back up
    databases: [ test2, test3 ]

    #Command Locations
    mysqldump_command: /usr/local/mysql/bin/mysqldump
    gzip_command: /usr/bin/gzip
    
If mysqldump_command, or gzip_command are left out, they will default to finding the applications in /usr/bin