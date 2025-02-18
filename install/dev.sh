#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input  branch name
echo -e "Enter your development branch name (default: 'devel'): \c"
read BRANCH
BRANCH=${BRANCH:-devel}
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> .env
export BRANCH

# Run git initialization script
if [ -f "./install/helpers/git-clone.sh" ]; then
    echo -e "\e[33mSetting up git clone...\e[0m"
    ./install/helpers/git-clone.sh
fi

# Set up app environment variables
if [ -x "$APP_NAME/.env.dev" ]; then
    echo -e "\e[33mSetting up application development environment variables...\e[0m"
    cp ./$APP_NAME/.env.dev ./$APP_NAME/.env
else
    echo -e "\e[31mError : No .env.dev file found in application folder.\e[0m"
fi

# Set permissions
if [ -f "./install/helpers/permissions.sh" ]; then
    echo -e "\e[33mSetting up permissions...\e[0m"
    ./install/helpers/permissions.sh
fi