#!/bin/bash

# Exit immediately if a command fails
set -e

if [ -z "$APP_ENV" ]; then
    APP_ENV="dev"
fi

# Check if the service environment file exists
if [[ ! -f ".env" && ! -f ".env.dist" && ! -f ".env.$APP_ENV" ]]; then
    echo -e "\e[31mNo compatible environment file found : .env|.env.dist|.env.$APP_ENV...\e[0m"
    exit 1
fi

# Check if the docker-compose file exists
if [[ ! -f "docker-compose.yml" && ! -f "docker-compose.yml.dist" && ! -f "docker-compose.yml.$APP_ENV" ]]; then
    echo -e "\e[31mNo compatible docker-compose file found : docker-compose.yml|docker-compose.yml.dist|docker-compose.yml.$APP_ENV...\e[0m"
    exit 1
fi

echo -e "\e[33mRunning mongodb-sk...\e[0m"

# Stopping existing containers
(
    echo -e "\e[33mStopping existing containers...\e[0m"
    docker-compose down
) &

# Copy environment and docker-compose files
(
    # Environment file
    (
        if [ -f ".env.$APP_ENV" ]; then
            echo -e "\e[33mCopying $APP_ENV environment file\e[0m"
            cp ".env.$APP_ENV" .env
            exit 1
        fi

        if [ -f ".env.dist" ]; then
            echo -e "\e[33mCopying .env.dist environment file\e[0m"
            cp .env.dist .env
            exit 1
        fi
    ) &
    # docker-compose file
    (
        if [ -f "docker-compose.yml.$APP_ENV" ]; then
            echo -e "\e[33mCopying $APP_ENV docker compose\e[0m"
            cp docker-compose.yml.$APP_ENV docker-compose.yml
            exit 1
        fi

        if [ -f "docker-compose.yml.dist" ]; then
            echo -e "\e[33mCopying docker-compose.yml.dist docker compose\e[0m"
            cp docker-compose.yml.dist docker-compose.yml
            exit 1
        fi
    ) &

    wait
    echo -e "\e[32mDocker-compose and environment file copied!\e[0m"
) &

wait
echo -e "\e[32mDocker and files ready!\e[0m"

# Building and starting containers
echo -e "\e[33mBuilding and starting container...\e[0m"
docker-compose up --build --remove-orphans -d

# Cleaning up unused Docker images
echo -e "\e[33mCleaning up unused Docker images...\e[0m"
docker system prune -af
