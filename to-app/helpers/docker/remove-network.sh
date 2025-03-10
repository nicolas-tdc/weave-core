#!/bin/bash

# Exit immediately if a command fails
set -e

NETWORK_NAME="${APP_NAME}_network"

# Remove app network if it exists
docker network ls --filter name="$NETWORK_NAME" -q > /dev/null
if [ $? -eq 0 ]; then
    docker network rm "$NETWORK_NAME"
    echo -e "\e[32mNetwork '$NETWORK_NAME' removed.\e[0m"
fi
