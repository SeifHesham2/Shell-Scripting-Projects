#!/bin/bash
# Make sure a file was supplied as an argument.
if [[ ${#} -ne 1 ]]
then
   echo "Usage: ${0} <Filename>" >&2
   exit 1
fi

FILE=${1}
if [[ ! -e ${FILE} ]]
then
   echo "The file does not exist." >&2
   exit 1
fi
# Display the CSV header.
echo 'Count , IP , Location' 

# Loop through the list of failed attempts and corresponding addresses.
grep Failed ${FILE} | awk -F 'from' '{print $2 }' | awk '{print $1 }' | sort | uniq -c | sort -nr | while read COUNT IP
do
# If the number of failed attempts is greater than the limit, display count, IP, and location.
if [[ ${COUNT} -gt 10 ]]
   then
     LOCATION=$(geoiplookup ${IP}| awk -F ', ' '{print $2}')
     echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0
  
