#!/bin/bash

VAR1=$1
REGEX="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

# argument check

if [ $# -ne 1 ]; then
  echo "Provide exactly one argument"
  exit 1
fi

# regex check

if ! [[ $VAR1 =~ $REGEX  ]]; then
  echo "No IP address provided"
  exit 2
fi

IP=${BASH_REMATCH[0]}

# find if ip address is reachable or not, if you don't want to see output "ping -c2 $IP > /dev/null"

ping -c2 $IP

if [ $? -eq 0 ]; then
  STATUS="OK"
else
  STATUS="NOT ANSWER"
fi

echo "IP: $IP STATUS: $STATUS"
