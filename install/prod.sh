#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input  branch name
echo -e "Enter your main branch name (default: 'main'): \c"
read BRANCH
BRANCH=${BRANCH:-main}
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> .env
export BRANCH

# Run git clone script
if [ -f "./install/helpers/git-clone.sh" ]; then
    echo -e "\e[33mSetting up git existing repository...\e[0m"
    ./install/helpers/git-clone.sh
fi

# Set up app environment variables
if [ -x "$APP_NAME/.env.prod" ]; then
    echo -e "\e[33mSetting up application production environment variables...\e[0m"
    cp ./$APP_NAME/.env.prod ./$APP_NAME/.env
else
    echo -e "\e[31mError : No .env.prod file found in application folder.\e[0m"
fi

# Set permissions
if [ -f "./install/helpers/permissions.sh" ]; then
    echo -e "\e[33mSetting up permissions...\e[0m"
    ./install/helpers/permissions.sh
fi