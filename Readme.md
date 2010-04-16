# RMyBackup

RMyBackup was created to solve a simple problem I had, and is hopefully useful to somebody else out there. It is a quick way to backup up specified mysql databases using mysqldump. It writes a gzipped .sql file using a date/time naming convention to a specified directory.

### To Install
    gem install rmybackup
    
## Usage

The gem will install an rmybackup binary. RMyBackup will read its configuration from /etc/rmybackup.conf (a sample configuration file is shown below). RMyBackup will backup the specified databases in the databases: [] list in the configuration file.

Right now the script relies on your [mysqldump] configuration in either /etc/my.cnf or the user's ~/.my.cnf. I'm hoping to change this soon, allowing you to specify the host, user, password, and socket in the configuration file.

    # example my.cnf
    #
    # [mysqldump]
    # user = root
    # password = roots_password
    

Once everything is set up correctly in the config file, and mysqldump is able to operate using credentials specified in the appropriate my.cnf file, you should simply be able to run the rmybackup command.

    # rmybackup


## Sample Configuration File

The default location for the configuration file is /etc/rmybackup.conf, formatted in YAML. You can specify a different config file on the command line using the --config_file (-f) switch.

    #Configuration File in YAML format

    #Backup Directory
    backup_dir: /Users/bshelton/mysql_tmp

    database_connection:
      host: localhost
      user: root
      password: batman

    #Databases to back up
    databases: [
      bercilak,
      etrack,
      bbpress
    ]

    #Command Locations
    mysqldump_command: /usr/local/mysql/bin/mysqldump
    gzip_command: /usr/bin/gzip
    find_command: /usr/bin/find
    
If mysqldump_command, gzip_command, or find_command are left out, they will default to finding the applications in /usr/bin