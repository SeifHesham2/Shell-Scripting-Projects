# Shell-Scripting-Projects
This repository contains various shell scripting projects that automate tasks or perform specific functions. Below is a brief overview of each script:

1-add-local-user.sh:
.Description: Creates a new local user on the system with the specified username, real name, and password. It enforces a password change on the user's first login.
.Usage: ./add-local-user.sh

2-add-newer-local-user.sh:
.Description: Adds a new local user to the system with enhanced security features. It generates a random password and sets it for the user. The script also allows specifying additional comments for the user.
.Usage: ./add-newer-local-user.sh USER_NAME [COMMENT]...

3-disable-local-user.sh:
.Description: Disables local user accounts on a Linux system. Optionally, it can delete the accounts, remove associated home directories, or create archives of home directories before deletion. It ensures the script is run with superuser privileges and handles various options.
Usage: ./disable-local-user.sh [-d] [-r] [-a] USER [USER]...
Options:
-d: Deletes accounts instead of disabling them.
-r: Removes the home directory associated with the account(s).
-a: Creates an archive of the home directory associated with the account(s).

4-backup_script.sh:
.Description: Checks the number of arguments passed to the script. If exactly one argument is provided (a filename), the script creates a backup of that file in the /var/tmp directory with a timestamp appended to its name. It uses syslog to log messages about the backup process.
.Usage: ./backup_script.sh <filename>

5-random_password_generator.sh:
Description: Generates a random password of specified length and optionally appends a special character to it. The user can set the password length with '-l' option and include a special character with '-s' option. Verbose mode can be enabled with '-v' option.
.Usage: ./random_password_generator.sh [-vs] [-l LENGTH]
.Options:
-l LENGTH: Specify the password length.
-s: Append a special character to the password.
-v: Increase verbosity.


