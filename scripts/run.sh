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
    (
        # Check if it's a directory
        if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
            echo "Entering directory: $dir"
            cd "$dir"

            if [ $APP_ENV == "dev" ] && [ -f ".env.dev" ]; then
                cp .env.dev .env
            fi

            if [ $APP_ENV == "prod" ] && [ -f ".env.prod" ]; then
                cp .env.prod .env
            fi

            # Stopping existing containers
            echo -e "\e[33mStopping existing containers...\e[0m"
            docker-compose down

            # Building and starting containers
            echo -e "\e[33mBuilding and starting container for service $dir...\e[0m"
            docker-compose up --build -d

            # Go back to the base directory
            cd - || exit
        fi
    ) &
done

wait

# Cleaning up unused Docker images
echo -e "\e[33mCleaning up unused Docker images...\e[0m"
docker system prune -af
