### API

# Add pub ssh key (Deploy key)
DEPLOY_KEY=$(curl -k --header \"PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}\" --header \"Content-Type: application/json\" --data '{\"title\": \"test\", \"key\": \"'\"$(cat id_rsa.pub)\"'\", \"can_push\": \"false\"}' \"https://gitlab.com/api/v4/projects/1/deploy_keys/\" | jq '.id')"

# Enable pub ssh key (Deploy key)
"curl -k --request POST --header \"PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}\" \"https://gitlab.com/api/v4/projects/1/deploy_key/${DEPLOY_KEY}/enable\""