# Shell Scripting Projects

This repository contains various shell scripting projects that automate tasks or perform specific functions. Below is a brief overview of each script:

### 1. add-local-user.sh

**Description:** Creates a new local user on the system with the specified username, real name, and password. It enforces a password change on the user's first login.

**Usage:** `./add-local-user.sh`

### 2. add-newer-local-user.sh

**Description:** Adds a new local user to the system with enhanced security features. It generates a random password and sets it for the user. The script also allows specifying additional comments for the user.

**Usage:** `./add-newer-local-user.sh USER_NAME [COMMENT]...`

### 3. disable-local-user.sh

**Description:** Disables local user accounts on a Linux system. Optionally, it can delete the accounts, remove associated home directories, or create archives of home directories before deletion. It ensures the script is run with superuser privileges and handles various options.

**Usage:** `./disable-local-user.sh [-d] [-r] [-a] USER [USER]...`

**Options:**  
- `-d`: Deletes accounts instead of disabling them.
- `-r`: Removes the home directory associated with the account(s).
- `-a`: Creates an archive of the home directory associated with the account(s).

### 4. backup_script.sh

**Description:** Checks the number of arguments passed to the script. If exactly one argument is provided (a filename), the script creates a backup of that file in the /var/tmp directory with a timestamp appended to its name. It uses syslog to log messages about the backup process.

**Usage:** `./backup_script.sh`

### 5. random_password_generator.sh

**Description:** Generates a random password of specified length and optionally appends a special character to it. The user can set the password length with '-l' option and include a special character with '-s' option. Verbose mode can be enabled with '-v' option.

**Usage:** `./random_password_generator.sh [-vs] [-l LENGTH]`

**Options:**  
- `-l LENGTH`: Specify the password length.
- `-s`: Append a special character to the password.
- `-v`: Increase verbosity.

### 6. show-attackers.sh

**Description:** Analyzes a log file to identify potential attackers by counting failed login attempts. It extracts IP addresses from the log file, counts their occurrences, and determines their geographic location using `geoiplookup`. If an IP address has more than 10 failed login attempts, it displays the count, IP address, and location.

**Usage:** `./show-attackers.sh <LOG_FILE>`

### 7. run-everywhere.sh

**Description:** Executes a command on every server specified in a list of servers. The script provides options for dry run mode, executing commands with sudo, and enabling verbose mode.

**Usage:** `./run-everywhere.sh [-nsv] [-f FILE] COMMAND`

**Options:**  
- `-f FILE`: Use FILE for the list of servers. Default: /vagrant/servers.
- `-n`: Dry run mode. Display the COMMAND that would have been executed and exit.
- `-s`: Execute the COMMAND using sudo on the remote server.
- `-v`: Verbose mode. Displays the server name before executing COMMAND.

### 8. Task_Scheduler.sh

**Description:** This script allows scheduling tasks using cron. It takes a schedule and a command as arguments and adds the task to the crontab.

**Usage:** `./Task_Scheduler.sh 'schedule' 'command'`

### 9. Server Health Monitoring Script

**Description:** This script monitors the CPU and memory usage of your server and sends email alerts if certain thresholds are exceeded.

**Prerequisites:**
- This script requires `mpstat` for CPU monitoring and `free` for memory monitoring.
- You need to have Python 3 installed on your system.

**Installation:**
1. Clone this repository to your server.
2. Ensure the script has executable permissions: `chmod +x server_health_monitor.sh`.

**Configuration:**
- Set thresholds for CPU and memory usage in the script.
- Provide your email address and password in the script for sending alerts.
- Ensure that the path to the Python script for sending emails is correct.

**Alerts:**
- If CPU usage exceeds the threshold, an alert email will be sent.
- If memory usage exceeds the threshold, an alert email will be sent.

**Additional Information:**
- The script logs CPU and memory usage to `/var/log/server_health.log`.
- A Python script for sending email alerts is included in the `scripts` folder.

### 10. Website Status Checker

**Description:** This script checks the status of websites listed in a specified file. It sends an email alert if a website is down.

**Usage:** `./website_status_checker.sh <filename>`

**Prerequisites:**
- The script requires `curl` for checking website status.
- You need to have Python 3 installed on your system.

**Configuration:**
- Set the email address and password in the script for sending alerts.
- Provide the correct path to the Python script for sending emails.

**Alerts:**
- If a website is down, an alert email will be sent.

**Note:**  
Make sure to replace `"path/to/python.py"` with the actual path to the Python script for sending emails.

