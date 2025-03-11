#!/bin/bash

# Exit immediately if a command fails
set -e

NETWORK_NAME="${APP_NAME}_network"

# Create app network if it doesn't exist
docker network ls --filter name="$NETWORK_NAME" -q > /dev/null
if [ $? -eq 0 ]; then
  echo -e "\e[33mCreating network '$NETWORK_NAME'...\e[0m"
  sudo docker network create "$NETWORK_NAME"
fi
