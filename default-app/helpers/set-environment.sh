#!/bin/bash

# Exit immediately if a command fails
set -e

# Application environment input defaults to dev
if [ -z "$1" ]; then
    APP_ENV="dev"
else
    APP_ENV=$1
fi
export $APP_ENV

# Check for environment input validity
if ! [[ "$APP_ENV" == "dev" || "$APP_ENV" == "staging" || "$APP_ENV" == "prod" ]]; then
    echo -e "\e[31mError: Invalid environment provided as first argument!\e[0m"
    echo -e "\e[31mAvailable: dev|staging|prod.\e[0m"
    exit 1
fi

# Check if the deploy-sk .env file exists
if ! [ -f "./.env.$APP_ENV" ]; then
    echo -e "\e[31mError: .env.$APP_ENV file not found in the app directory.\e[0m"
    exit 1
fi

# Get development environment variables
echo -e "\e[33mSet $APP_ENV environment variables...\e[0m"
sudo cp ".env.$APP_ENV" ".env"
source .env

# Get app name from directory name
APP_NAME=$(basename "$PWD") > /dev/null 2>&1
export APP_NAME
