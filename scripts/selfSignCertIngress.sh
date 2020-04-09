#!/bin/bash

DOMAIN=$1
NAMESPACE=$2


openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${DOMAIN}.key -out ${DOMAIN}.crt -subj "/CN=${DOMAIN}/O=${DOMAIN}"

kubectl -n ${NAMESPACE} create secret tls tls-${DOMAIN} --key ${DOMAIN}.key --cert ${DOMAIN}.crt
