#!/bin/bash

# Script: website_status_checker.sh
# Description: This script is used to check websites status and send alert if down.
# Author: Seif Seddik
# Date: Wednesday, April 21, 2024


# Email address to send alerts to
ALERT_MAIL="admin@gmail.com"
PASSWORD="adminpassword"


# Path to the Python script for sending emails
SEND_EMAIL_SCRIPT="path/to/python.py"


# Function to display usage information
usage(){
    echo "Usage: ${0} <filename>" >&2
    echo "This script checks the status of websites listed in the specified file." >&2
    exit 1
}

# Check if script is run as root
if [[ ${UID} != 0 ]]; then
    echo "Insufficient privileges. Please run this script with sudo." >&2
    exit 1
fi

# Check if the correct number of arguments is provided
if [[ ${#} != 1 ]]; then
    usage
fi

# Define the filename containing website URLs
WEBSITES_FILE="${1}"

# Function to check send alert to email
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


# Function to check website status
check_status() {
    while read -r URL;
    do
        # Retrieve the HTTP status code of the website
        STATUS=$(curl -s --head "${URL}" | awk '/HTTP/ {print $2}')
        
        # Check if STATUS is empty (i.e., curl did not output HTTP status code)
        if [[ -z "${STATUS}" ]]; then
            echo "Error: Unable to retrieve HTTP status code for ${URL}" >&2
            continue  # Continue to the next URL
        fi

        # Check the status code and sendemail if the website is down
        case "${STATUS}" in
            200 | 301 ) echo "${URL} is up. Status code: ${STATUS}";;
            *)  echo "${URL} is down. Status code: ${STATUS}" 
                send_alert "Your Website is down" "The webite with this url: ${URL} is down . with stauts code: ${STATUS}"
                ;;
            
        esac
    done < "${WEBSITES_FILE}" 
}


# Check if the website file exists
if [[ -e ${WEBSITES_FILE} ]]; then
    # Check if the website file is empty
    if [[ ! -s ${WEBSITES_FILE} ]]; then
        echo "The websites file is empty. Please provide a list of URLs." >&2
        exit 1
    else
        # Call the function to check website status
        check_status
    fi
else
    echo "The specified file (${WEBSITES_FILE}) does not exist. Please provide a valid file." >&2
    exit 1
fi

exit 0

