#!/bin/bash

# Script: schedule_task.sh
# Description: This script is used to schedule tasks using cron.
# Author: Seif Seddik
# Date: Wednesday, April 17, 2024

# Usage statement
usage (){
    echo "Usage: $0 'schedule' 'command'" >&2
    echo "Example: $0 '0 * * * *' '/path/to/script.sh'" >&2
    exit 1
}

# Assign the arguments to variables
SCHEDULE="${1}"
COMMAND="${2}"
NUMBER_OF_ARG=${#}
PATH_OF_THE_SCRIPT=$(echo "${COMMAND}" | awk '{print $2}')

if [[ ${NUMBER_OF_ARG} -lt 2 ]]; then
    usage
fi

if [[ ! -x ${PATH_OF_THE_SCRIPT} ]]; then
    echo "Error: Invalid command path. Please provide a valid executable path." >&2
    exit 1
fi

# Function to add a new scheduled task
add_task()
{
    # Prepare the new task
    NEW_TASK="$SCHEDULE $COMMAND"

    # Get the current list of tasks, suppress any error messages
    CURRENT_TASKS=$(crontab -l 2>/dev/null)

    # Combine the current jobs with the new task
    NEW_TASKS="$CURRENT_TASKS
$NEW_TASK"

    # Apply the new set of tasks
    echo "$NEW_TASKS" | crontab - 2>/dev/null

    # Check the status
    if [[ ${?} -ne 0 ]]; then
        echo "Task scheduling failed" >&2
        exit 1
    else
        # Confirm the new task has been scheduled
        echo "Task scheduled: $NEW_TASK"
    fi
}

# Add the new task to be scheduled
add_task

# Display all the scheduled tasks
echo "Current tasks scheduled:"
crontab -l
exit 0

