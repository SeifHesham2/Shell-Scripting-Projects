#!/bin/bash

# Set thresholds for CPU and memory usage
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80

# Email address to send alerts to
ALERT_MAIL="admin@gmail.com"
PASSWORD="adminpassword"

# Log file path
LOG_FILE="/var/log/server_health.log"

# Path to the Python script for sending emails
SEND_EMAIL_SCRIPT="path/to/python.py"

# Check if the script is run as root
if [[ ${UID} -ne 0 ]] 
 then
  echo "You should use sudo privilege" >&2
  exit 1
fi

# Check if the log file exists
if [[ ! -e ${LOG_FILE} ]]
  then 
     touch /var/log/server_health.log
fi

# Measure CPU usage and log it
CPU_USAGE=$(mpstat 1 1 | awk '/Average:/ {print 100 - $NF}')
echo "CPU usage: ${CPU_USAGE}%" >> $LOG_FILE

# Measure memory usage and log it
MEMORY_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
echo "Memory usage: ${MEMORY_USAGE}%" >> $LOG_FILE

# Function to send email alert using Python script
send_alert() {
  SUBJECT="${1}"
  BODY="${2}"
  # Call the Python script to send email
  python3 "${SEND_EMAIL_SCRIPT}" --sender-email "${ALERT_MAIL}" --sender-password "${PASSWORD}" --recipient-email "${ALERT_MAIL}" --subject "${SUBJECT}" --message "${BODY}"

  if [ $? -ne 0 ] 
   then
    echo "Failed to send email alert" >&2
  else
    echo "Email alert sent successfully"
  fi
}

# Check if CPU usage exceeds threshold and send alert if it does
if [[ ${CPU_USAGE} > ${CPU_THRESHLOD} ]]
then
  send_alert "CPU Usage Alert" "Usage is high: ${CPU_USAGE}% on ${hostname}"
fi

# Check if memory usage exceeds threshold and send alert if it does
if [[ ${MEMORY_USAGE} > ${MEMORY_THRESHLOD} ]]
 then
  send_alert "Memory Usage Alert" "Usage is high: ${MEMORY_USAGE}% on ${hostname}"
fi

