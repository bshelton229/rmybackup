## 0.4.0

  - You can now set push URIs in the config file. They can be either a single value or a list (array). RMyBackup will attemp to rsync the backup directory to each push URI after backups have completed.
  - The rmybackup CLI binary got --edit and --list options. --edit will bring the config file up in an editor (uses $EDITOR or defaults to vim). --list will list the current config file contents and display it's location.
  - The binary files are not auto-detected if they aren't specified in the config file.