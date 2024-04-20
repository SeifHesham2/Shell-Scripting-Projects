#!/bin/bash

# Check the number of argumnets. 

if [[ "${#}" -ne 1 ]]
then
  echo "Usage:${0} <filename>" >&2
  exit 1
fi 

log(){
# This fucntion sends a message to syslog.
  local MESSAGE="${@}"
  echo "${MESSAGE}"
  logger -t "${0}" "${MESSAGE}"
}

backup_file(){
# This function creates a backup of a file . Returns non-zero status on error.

local FILE="${1}"

#check if the file exists
if [[ -f "${FILE}" ]] 
 then 
   local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
   log "Backing up ${FILE} to ${BACKUP_FILE}."

  # The exit status of the fucntion will be the exit status of the cp command.
   cp -p ${FILE} ${BACKUP_FILE}
else 
  # The file does not exist , so return a non-zero exit status.
  log "Error: ${FILE} does not exist."
  return 1
fi 

}

backup_file "${1}"
# make a decision based on the exit status of the fucntion
if [[ ${?} -eq 0 ]] 
then 
  log 'File backup succeeded!'
else 
  log 'File backup failed!'
  exit 1 
fi 


