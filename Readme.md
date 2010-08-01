# RMyBackup

RMyBackup was created to solve a simple problem I had, and is hopefully useful to somebody else out there. RMyBackup is a quick way to backup up your mysql databases using mysqldump. It writes a gzipped .sql file using a date/time naming convention to a specified directory.

### To Install
    # gem install rmybackup
    
## Usage

The gem will install an rmybackup binary. RMyBackup will read its configuration from ~/.rmybackup.conf or /etc/rmybackup.conf (a sample configuration file is shown below). The .rmybackup.conf file in your home folder will be used if present, next rmybackup will look for /etc/rmybackup. You may also specify an alternate config file on the command line using rmybackup --config-file /alternate/config/file. RMyBackup will backup all databases excluding the databases listed in the skip_databases: [] list in the configuration file.

To generate a sample config file, use the --instal-config option. Default location is /etc/rmybackup.conf, or if we can't write to /etc, ~/.rmybacukp.conf.

    # rmybackup --install-config [/config/location]
    
Rmybackup --edit and --list will edit and list the config file respectively. Edit will use the EDITOR environment variable, or search for vim.

    # rmybackup --edit
    # rmybackup --list

If use_mycnf_credentials is set to true in the config file, mysqldump will not be passed --user, --password, or --host based on the values in the config file. The script will rely on your [mysqldump] configuration in either /etc/my.cnf or the user's ~/.my.cnf. This is more secure if running on a shared server.

    # example my.cnf or ~/.my.cnf
    
    [mysqldump]
    user = root
    password = roots_password

RMyBackup will also use rsync to sync to URIs listed in the push configuration file option. For example, if you set push: user@server:/remote/path, after the backups were completed, rmybackup would run rsync -rz /local/backup/path/ user@server:/remote/path/. Push can either be a list or URIs or a single URI.

    push: [ "username@server:/directory/for/backups", 
            "another_user@another_server:/directory/for/backups" ]

Once everything is set up, simply run the rmybackup command. It will connect to the mysql server using the values in your config file and back up your databases.

    # rmybackup


## Sample Configuration File

The default location for the configuration file is /etc/rmybackup.conf then ~/.rmybacukp.conf, it's formatted in YAML. You can specify a different config file on the command line using the --config-file (-f) option.

    ---
    backup_dir: /Users/username/mysql_backups/

    #Pruning. Remove_after is evaluated first, then only_keep

    #Remove after x days
    #remove_after: 7

    #Only keep x number
    #only_keep: 5

    #Database
    username: root
    password: password
    host: localhost

    #If use_mycnf_credentials is set to true, no --user --password or --host switches will be passed to mysqldump
    use_mycnf_credentials: false

    #Databases to not back up
    skip_databases: [ mysql, test, information_schema ]


    #RMyBackup will use Rsync to push to the Rsync compatible URI's listed in push:. This can be a single value or a list.

    #push: [ "username@server:/directory/for/backups", 
    #        "another_user@another_server:/directory/for/backups" ]


    #Command Locations
    #You may override where to find the needed system commands
    #RMyBackup will try to locate these files if they are not specified here

    #mysqldump_command: /usr/local/mysql/bin/mysqldump
    #gzip_command: /usr/bin/gzip

    #Rsync, only needed if you designate pushes
    #rsync_command: /usr/bin/rsync
