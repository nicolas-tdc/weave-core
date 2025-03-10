#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/set-environment.sh $1
fi

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./helpers/install-required.sh
fi

# @todo: necessary ? needs login logout so maybe indicate in documentation
# Check if user is in Docker group
if ! groups "$USER" | grep -q "\bdocker\b"; then
    # Add user to Docker group
    echo -e "\e[33mAdding user to Docker group...\e[0m"
    sudo usermod -aG docker $USER
fi

# Add network if it doesn't exist already
NETWORK_NAME="${APP_NAME}_network"

# Check if the network exists
docker network ls --filter name="$NETWORK_NAME" -q > /dev/null
if [ $? -eq 0 ]; then
  echo -e "\e[32mNetwork '$NETWORK_NAME' already exists.\e[0m"
else
  echo -e "\e[33mCreating network '$NETWORK_NAME'...\e[0m"
  sudo docker network create "$NETWORK_NAME"
fi

# Runs all services
for SERVICE_PATH in ./*/; do
    (
        # Check if it's a directory
        if [ -d "$SERVICE_PATH" ] && [ -f "${SERVICE_PATH}scripts/run.sh" ]; then
            cd "$SERVICE_PATH"
            scripts/run.sh
            cd - || exit
        fi
    ) &
done

wait

echo -e "\e[32mAll services running!\e[0m"
