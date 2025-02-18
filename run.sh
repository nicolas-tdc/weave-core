#!/bin/bash

# Exit immediately if a command fails
set -e

# Check if the deploy-sk .env file exists
if ! [ -f "./.env" ]; then
    echo -e "\e[31mError: .env file not found in the deploy-sk directory.\e[0m"
    exit 1
fi

# Get development environment variables
echo -e "\e[33mGet environment variables...\e[0m"
source .env

# Navigate to the app directory
cd "$APP_NAME"

if ! [ -f "./docker-compose.yml" ]; then
    echo -e "\e[31mError: docker-compose.yml file not found in the app directory.\e[0m"
    exit 1
fi

# Pull latest changes
echo -e "\e[33mPulling latest changes...\e[0m"
git pull origin $BRANCH

# Stopping existing containers
echo -e "\e[33mStopping existing containers...\e[0m"
docker-compose down

# Building and starting containers
echo -e "\e[33mBuilding and starting containers...\e[0m"
docker-compose up --build -d

# Cleaning up unused Docker images
echo -e "\e[33mCleaning up unused Docker images...\e[0m"
docker system prune -af

# Running app specific deploy script
if [ -x "./scripts/deploy.sh" ]; then
    echo -e "\e[33mRunning app specific deploy script...\e[0m"
    ./scripts/deploy.sh
fi
