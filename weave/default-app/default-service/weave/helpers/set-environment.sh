#!/bin/bash

# Exit immediately if a command fails
set -e

SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1
export SERVICE_NAME

# Set application environment if not set
if [ -z "$APP_ENV" ]; then
    if ! [ -z "$1" ]; then
        APP_ENV="$1"
    else
        APP_ENV="dev"
    fi
fi
export APP_ENV

# Check if the service environment file exists
if [[ ! -f ".env" && ! -f ".env.dist" && ! -f ".env.$APP_ENV" ]]; then
    echo -e "\e[31m$SERVICE_NAME: No compatible environment file found : .env|.env.dist|.env.$APP_ENV...\e[0m"
    exit 1
fi

# Check if the docker-compose file exists
if [[ ! -f "docker-compose.yml" && ! -f "docker-compose.yml.dist" && ! -f "docker-compose.yml.$APP_ENV" ]]; then
    echo -e "\e[31m$SERVICE_NAME: No compatible docker-compose file found : docker-compose.yml|docker-compose.yml.dist|docker-compose.yml.$APP_ENV...\e[0m"
    exit 1
fi

# Copy relevant environment file
if [ -f ".env.$APP_ENV" ]; then
    echo -e "\e[33$SERVICE_NAME: Copying $APP_ENV environment file...\e[0m"
    sudo cp ".env.$APP_ENV" .env
elif [ -f ".env.dist" ]; then
    echo -e "\e[33m$SERVICE_NAME: Copying .env.dist environment file...\e[0m"
    sudo cp .env.dist .env
else
    echo -e "\e[33m$SERVICE_NAME: Backing-up .env file...\e[0m"
    sudo cp .env .env.dist
fi

# Copy relevant docker-compose file
if [ -f "docker-compose.yml.$APP_ENV" ]; then
    echo -e "\e[33m$SERVICE_NAME: Copying $APP_ENV docker compose file...\e[0m"
    sudo cp docker-compose.yml.$APP_ENV docker-compose.yml
elif [ -f "docker-compose.yml.dist" ]; then
    echo -e "\e[33m$SERVICE_NAME: Copying dist docker compose file...\e[0m"
    sudo cp docker-compose.yml.dist docker-compose.yml
else
    echo -e "\e[33m$SERVICE_NAME: Backing-up docker-compose.yml...\e[0m"
    sudo cp docker-compose.yml docker-compose.yml.dist
fi

echo -e "\e[32m$SERVICE_NAME: Docker-compose and environment file ready.\e[0m"
