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

# Stop all services
for SERVICE_PATH in ./*/; do
    (
        # Check if it's a directory
        if [ -d "$SERVICE_PATH" ] && [ -f "${SERVICE_PATH}scripts/stop.sh" ]; then
            cd "$SERVICE_PATH"
            scripts/stop.sh
            cd - || exit
        fi
    ) &
done

wait

echo -e "\e[32mAll services stopped!\e[0m"

# Remove network if it exists
NETWORK_NAME="${APP_NAME}_network"
docker network ls --filter name="$NETWORK_NAME" -q > /dev/null
if [ $? -eq 0 ]; then
    docker network rm "$NETWORK_NAME"
    echo -e "\e[32mNetwork '$NETWORK_NAME' removed.\e[0m"
fi

echo -e "\e[32mApplication stopped!\e[0m"