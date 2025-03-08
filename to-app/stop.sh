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

# Runs all services
for dir in "$APP_NAME"/*/; do
    # Check if it's a directory
    if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
        cd "$dir"

        # Stopping existing containers
        echo -e "\e[33mStopping existing containers...\e[0m"
        docker-compose down

        # Go back to the base directory
        cd - || exit
    fi
done

# Cleaning up unused Docker images
echo -e "\e[33mCleaning up unused Docker images...\e[0m"
docker system prune -af

