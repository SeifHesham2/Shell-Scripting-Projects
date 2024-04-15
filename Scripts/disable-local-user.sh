#!/bin/bash



# Display the usage and exit.
usage(){ 
echo "Usage: ${0} [-dra] USER [USER]...">&2
echo 'Disable a local linux account'>&2
echo   ' -d   Deletes accounts instead of disabling them.'>&2
echo   ' -r   Removes the home directory associated with the account(s).'>&2
echo   ' -a   Creates an archive of the home directory associated with the accounts(s)'>&2
exit 1 
}



# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -ne 0 ]]
then 
   echo 'You should use the sudo privilege'>&2
   exit 1;
fi 


# Parse the options.
while getopts dra OPTIONS
do
   case ${OPTIONS} in 
   d) DELETE_USER='true' ;;
   r) DELETE_USER_DIR='true' ;;
   a) ARCHIVE='true' ;; 
   ?) usage ;;
  esac
done


# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"
# If the user doesn't supply at least one argument, give them help.
if [[ ${#} -lt 1 ]] 
then 
  usage 
fi 

readonly ARCHIVE_DIR='/archive'

# Loop through all the usernames supplied as arguments.
for USER_NAME in "${@}"
do
  # Make sure the UID of the account is at least 1000. 
  USERID=$( id -u ${USER_NAME})
  if [[ "${USERID}" -lt 1000 ]]
  then 
     echo "Refusing to remove the ${USER_NAME} account with UID ${USERID}.">&2
     exit 1
  fi

  # Create an archive
  if [[ "${ARCHIVE}" = 'true' ]]
  then
  # Make sure the ARCHIVE_DIR directory exists.
      if [[ ! -d ${ARCHIVE_DIR} ]]
      then
         mkdir -p ${ARCHIVE_DIR}
      fi

  HOME_DIR="/home/${USER_NAME}"
  ARCHIVE_FILE="/${ARCHIVE_DIR}/${USER_NAME}.tgz"
 
  # Archive the user's home directory and move it into the ARCHIVE_DIR
      if [[ -d "${HOME_DIR}" ]]
      then
         tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
         if [[ "${?}" -ne 0 ]]
         then
           echo "Could not create ${ARCHIVE_FILE}" >&2
           exit 1
         fi
      else
           echo "${HOME_DIR} of ${USER_NAME} does not exist or is not a directory." >&2
           exit 1
      fi
   fi


  # Delete the user.
  if [[ "${DELETE_USER}" = 'true' ]]
  then
    # Check to see if the -r is true to froce delete User dir 
    if [[ ${DELETE_USER_DIR} -eq 'true' ]]
    then  
    userdel -r ${USER_NAME}
    else 
    userdel ${USER_NAME} 
    fi 
    # Check to see if the userdel command succeeded
      if [[ "${?}" -ne 0 ]]
      then 
        echo "The account who has username = ${USER_NAME} was not deleted." >&2
        exit 1
      fi 
      echo " The account who has username = ${USER_NAME} was deleted."
  else 
      chage -E 0 ${USER_NAME} 
   # Check to see if the chage command succeeded.
      if [[ "${?}" -ne 0 ]]
      then
        echo "The account who has username = ${USER_NAME} was not disabled." >&2
        exit 1
      fi 
      echo " The account who has username = ${USER_NAME} was disabled."
          
   fi  
done
exit 0




