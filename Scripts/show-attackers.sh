#!/bin/bash

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

echo 'Count , IP , Location' 


grep Failed ${FILE} | awk -F 'from' '{print $2 }' | awk '{print $1 }' | sort | uniq -c | sort -nr | while read COUNT IP
do
  if [[ ${COUNT} -gt 10 ]]
   then
     LOCATION=$(geoiplookup ${IP}| awk -F ', ' '{print $2}')
     echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0
  
