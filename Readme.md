# RMyBackup

RMyBackup was created to solve a simple problem I had, and is hopefully useful to somebody else out there. RMyBackup is a quick way to backup up your mysql databases using mysqldump. It writes a gzipped .sql file using a date/time naming convention to a specified directory.

### To Install
    # gem install rmybackup
    
## Usage

The gem will install an rmybackup binary. RMyBackup will read its configuration from ~/.rmybackup.conf or /etc/rmybackup.conf (a sample configuration file is shown below). The .rmybackup.conf file in your home folder will be used if present, next rmybackup will look for /etc/rmybackup. You may also specify an alternate config file on the command line using rmybackup --config-file /alternate/config/file. RMyBackup will backup all databases excluding the databases listed in the skip_databases: [] list in the configuration file.

To generate a sample config file, use the --instal-config option. Default location is /etc/rmybackup.conf, or if we can't write to /etc, ~/.rmybacukp.conf.

    # rmybackup --install-config [/config/location]

If use_mycnf_credentials is set to true in the config file, mysqldump will not be passed --user, --password, or --host based on the values in the config file. The script will rely on your [mysqldump] configuration in either /etc/my.cnf or the user's ~/.my.cnf. This is more secure if running on a shared server.

    # example my.cnf or ~/.my.cnf
    
    [mysqldump]
    user = root
    password = roots_password
    

Once everything is set up, simply run the rmybackup command. It will connect to the mysql server using the values in your config file and back up your databases.

    # rmybackup


## Sample Configuration File

The default location for the configuration file is /etc/rmybackup.conf then ~/.rmybacukp.conf, it's formatted in YAML. You can specify a different config file on the command line using the --config-file (-f) option.

    ---
    backup_dir: /Users/username/mysql_backups/
    
    #Pruning. Remove_after is evaluated first, then only_keep

    #Remove after x days
    remove_after: 7

    #Only keep x number
    only_keep: 5

    #Database
    username: root
    password: password
    host: localhost

    #If this is set to true, no --user --password or --host switches will be passed to
    #mysqldump. You will need to have credentials within /etc/my.cnf or ~/.my.cnf
    use_mycnf_credentials: false

    #Databases to back up
    skip_databases: [ mysql, test, information_schema ]

    #Command Locations
    #You can override where to find the needed system commands, default locations are prefixed with /usr/bin/

    #mysqldump_command: /usr/local/mysql/bin/mysqldump
    #gzip_command: /usr/bin/gzip
    
If mysqldump_command, or gzip_command are left out, they will default to finding the applications in /usr/bin