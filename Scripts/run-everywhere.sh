#!/bin/bash


# Function to display usage information
usage(){
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND"
  echo "Executes COMMAND as a single command on every server."
  echo "  -f FILE Use FILE for the list of servers. Default: /vagrant/servers."
  echo "  -n Dry run mode. Display the COMMAND that would have been executed and exit."
  echo "  -s Execute the COMMAND using sudo on the remote server."
  echo "  -v Verbose mode. Displays the server name before executing COMMAND."
  exit 1
}

# Default server file path
FILE='/vagrant/servers'

# Make sure the script is not being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]; then
  echo "Do not execute this script as root. Use the -s option instead." >&2
  usage
fi

# Parse the options.
while getopts f:nsv OPTION; do
  case ${OPTION} in
    f) FILE="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO_COMMAND='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage;;
  esac
done

shift "$((OPTIND - 1))"

# Ensure that at least one command is provided.
if [[ "${#}" -lt 1 ]]; then
  usage
fi

COMMAND="${@}"

SSH_EXIT_STATUS=0

# Make sure the server list file exists.
if [[ ! -e ${FILE} ]]; then
  echo "The server list file ${FILE} does not exist." >&2
  exit 1
fi

# Loop through the server list.
for SERVER in $(cat ${FILE}); do
  # Display the server name if in verbose mode.
  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "Executing on ${SERVER}: ${COMMAND}"
  fi

  # If it's a dry run, don't execute anything, just echo it.
  if [[ "${DRY_RUN}" = 'true' ]]; then
    echo "Dry run: The command to be executed on ${SERVER} is: ${COMMAND}"
  else
    # Execute the command remotely via SSH.
    ssh -o ConnectTimeout=2 ${SERVER} ${SUDO_COMMAND} ${COMMAND}
    SSH_EXIT_STATUS="${?}"
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]; then
      EXIT_STATUS="${SSH_EXIT_STATUS}"
      echo "Execution on ${SERVER} failed." >&2
    fi
  fi
done
exit ${EXIT_STATUS}


