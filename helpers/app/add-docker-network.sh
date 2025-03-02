#!/bin/bash

# Exit immediately if a command fails
set -e

NETWORK_NAME="${APP_NAME}_network"

# Check if the network exists
docker network ls --filter name="$NETWORK_NAME" -q > /dev/null

# $? checks the exit status of the last command (0 = success, 1 = failure)
if [ $? -eq 0 ]; then
  echo "Network '$NETWORK_NAME' already exists."
else
  sudo docker network create "$NETWORK_NAME"
fi
