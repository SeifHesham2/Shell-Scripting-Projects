#!/bin/bash

# Ensure the script is being executed with superuser privileges.
if [[ ${UID} != 0 ]]
then
  echo "Please run this script with sudo privileges." >&2
  exit 1
fi

# Check if at least one argument (username) is provided.
if [[ ${#} -lt 1 ]]
then
  echo "Usage: $0 USER_NAME [COMMENT]..." >&2
  exit 1
fi

# Extract username and comments from command line arguments.
USER_NAME=${1}
shift
COMMENT="${@}"

# Generate a password
PASSWORD=$(date +%s%n${RANDOM}${RANDOM}| sha256sum | head -c48)
SPECIAL_CHAR=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
PASSWORD=${PASSWORD}${SPECIAL_CHAR}

# Create the user with the provided username and comments.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Check if the useradd command succeeded.
if [[ ${?} != 0 ]]
then
  echo "Failed to create user ${USER_NAME}. Please check if the user already exists or try again." >&2
  exit 1
fi

# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check if the chpasswd command succeeded.
if [[ ${?} != 0 ]]
then
  echo "Failed to set password for user ${USER_NAME}. Please try again." >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the hostname where the user was created.
echo "User '${USER_NAME}' successfully created."
echo "Password for '${USER_NAME}' is: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"

exit 0



