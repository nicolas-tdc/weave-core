#!/bin/bash

# Exit immediately if a command fails
set -e

# Check if the deploy-sk .env file exists
if ! [ -f "./.env.common" ]; then
    echo -e "\e[31mError: .env.common file not found in the deploy-sk directory.\e[0m"
    exit 1
fi

# Get development environment variables
echo -e "\e[33mGet environment variables...\e[0m"
source .env.common


# Check if user is in Docker group
if ! groups "$USER" | grep -q "\bdocker\b"; then
    # Add user to Docker group
    echo -e "\e[33mAdding user to Docker group...\e[0m"
    sudo usermod -aG docker $USER
fi

if [ -f "./helpers/app/add-docker-network.sh" ]; then
    echo -e "\e[33mAdding app docker network...\e[0m"
    ./helpers/app/add-docker-network.sh
fi

# Runs all services
for DIR in "$APP_NAME"/*/; do
    (
        # Check if it's a directory
        if [ -d "$DIR" ] && [ -f "${DIR}scripts/run.sh" ]; then
            cd "$DIR"
            scripts/run.sh
            cd - || exit
        fi
    ) &
done

wait

echo -e "\e[32mAll services running\e[0m"
