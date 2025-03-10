#!/bin/bash

# Exit immediately if a command fails
set -e

export APP_ENV=$1

# Check for environment input validity
if [ -z "$APP_ENV" ] && ! [ "$APP_ENV" == "dev"] && ! [ "$APP_ENV" == "staging"] && ! [ "$APP_ENV" == "prod" ]; then
    echo -e "\e[31mError: Invalid environment provided as first argument!\e[0m"
    echo -e "\e[33mAvailable: dev|staging|prod.\e[0m"
    exit 1
fi

# Check if the deploy-sk .env file exists
if ! [ -f "./.env.$APP_ENV" ]; then
    echo -e "\e[31mError: .env.$APP_ENV file not found in the app directory.\e[0m"
    exit 1
fi

# Get development environment variables
echo -e "\e[33mSet environment variables...\e[0m"
cp ".env.$APP_ENV" ".env"
source .env
