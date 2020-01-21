#!/bin/bash

echo "enter the client data to create an organization"
echo
echo "Organization Login to enter a service"
read -p '[username]: ' username
echo "Organization Password to enter a service"
read -p '[password]: ' password
echo "Number of total available CPU for creating clusters(Specified in cores, integers)"
read -p '[cpu]: ' cpu
echo "Number of total available RAM for creating clusters (Specified in gigabytes, integers)"
read -p '[memory]: ' memory

echo "Check that entered data is correct: "
echo "[username: $username] 
[password: $password]
[cpu: $cpu]
[memory: $memory]"

client_data()
{
  cat <<EOF
{
    "username": "$username",
    "password": "$password",
    "cpu": $cpu,
    "memory": $memory
}
EOF
}

while true; do
    read -p "Create organization?: " YN
    case $YN in
        [Yy]* ) curl -X POST https://someservice/create -d "$(client_data)"; break;;
        [Nn]* ) exit;;
        * ) echo "Please, enter Y(Yes) or N(No)";;
    esac
done
