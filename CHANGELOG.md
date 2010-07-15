## 0.3.7
  - Exit with 1 now if the config file we're trying to --list or --edit doesn't exist

## 0.3.6
  - The config file is no longer validated before --list and --edit, so you can --edit and --list the example file installed with --install
  - Fixed detecting whether or not we can write to /etc/rmybackup.conf when sudo rmybackup --install is run

## 0.3.5

  - You can now set push URIs in the config file. They can be either a single value or a list (array). RMyBackup will attemp to rsync the backup directory to each push URI after backups have completed.
  - The rmybackup CLI binary got --edit and --list options. --edit will bring the config file up in an editor (uses $EDITOR or defaults to vim). --list will list the current config file contents and display it's location.
  - The binary files are now auto-detected if they aren't specified in the config file.
