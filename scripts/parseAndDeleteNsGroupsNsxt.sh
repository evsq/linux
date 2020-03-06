#!/bin/bash

# Enter your credentials
export NSXT_USER="user"
export NSXT_PASSWORD="password"
export NSXT_URL="https://yournsxturl/api/v1/ns-groups"

# Download list nsgroups in file
echo "download list nsgroups"
curl -k -u $NSXT_USER:$NSXT_PASSWORD $NSXT_URL > nsgroups

# Example sed commands for delete unnecessary information in file
echo "clean unnecessary lines"
sed '/"id"/!d' nsgroups > IdNsgroups
sed -i 's/    "id" : "//g' IdNsgroups
sed -i 's/",//g' IdNsgroups
sed -i 's/      "target_property" : "id//g;/^$/d' IdNsgroups
sed -i '1,32d' IdNsgroups

# Delete each line in file
echo "delete nsgroups"
input="IdNsgroups"
while IFS= read -r line
do
  curl -X DELETE -k -u $NSXT_USER:$NSXT_PASSWORD $NSXT_URL/$line
done < "$input"

