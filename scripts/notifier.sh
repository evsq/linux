#!/bin/bash

if journalctl -eu someservice | grep -q "panic"; then
  curl -X POST -H 'Content-type: application/json' -d '{"text":"Service is in a Panic!"}' https://hooks.slack.com/services/webhook
  echo "Service is OK!"
fi

# for example set crontab
# crontab -e
# */5 * * * * /bin/notification-panic.sh
