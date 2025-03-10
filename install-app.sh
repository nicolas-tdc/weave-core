#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application installation!\e[0m"

# Set and source environment variables
APP_ENV=$1

if [ -z "$APP_ENV" ] && ! [ "$APP_ENV" == "dev"] && ! [ "$APP_ENV" == "staging"] && ! [ "$APP_ENV" == "prod" ]; then
    echo -e "\e[31mError: No compatible environment provided as first argument!\e[0m"
    echo -e "\e[33mAvailable: dev|staging|prod.\e[0m"
    exit 1
fi

cp ".env.$APP_ENV" ".env"
source .env

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    source ./helpers/install-required.sh
fi

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$BRANCH" "$APP_REPOSITORY" "$APP_NAME"

echo -e "\e[32mApplication installed!\e[0m"
