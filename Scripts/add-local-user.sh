#!/bin/bash

#check if the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo "Error: This script must be run as root"
    exit 1
fi

# Get the username (login).
read -p "Enter the username: " username

# Get the real name (contents for the description field).
read -p "Enter the real name: " realname

# Get the password.
read -s -p "Enter the password: " password
echo

# Create the user with the password.
useradd -c "$realname" -m "$username"

# Check if the useradd command succeeded.
if [[ ${?} -ne 0 ]] 
then
    echo "Error: Failed to create user"
    exit 1
fi

# Set the password.
echo ${password} | passwd --stdin ${username}

# Check if the passwd command succeeded.
if [[ ${?} -ne 0 ]]
then
    echo "Error: Failed to set password"
    exit 1
fi

# Force password change on first login.
passwd -e "$username"

# Display the username, password, and the host where the user was created.
echo "User '$username' created with password '$password' on host '$(hostname)'"

