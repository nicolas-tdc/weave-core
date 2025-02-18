#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input main branch name
echo -e "Enter your git main branch name (default: 'main'): \c"
read MAIN_BRANCH
MAIN_BRANCH=${MAIN_BRANCH:-main}
export MAIN_BRANCH

# Input  branch name
echo -e "Enter your development branch name (default: 'devel'): \c"
read BRANCH
BRANCH=${BRANCH:-devel}
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> .env
export BRANCH

# Run git initialization script
if [ -f "./install/helpers/git-initialize.sh" ]; then
    echo -e "\e[33mSetting up git initialization...\e[0m"
    ./install/helpers/git-initialize.sh
fi

# Set up app environment variables
if [ -x "$APP_NAME/.env.dev" ]; then
    echo -e "\e[33mSetting up application development environment variables...\e[0m"
    cp ./$APP_NAME/.env.dev ./$APP_NAME/.env
else
    echo -e "\e[31mError : No .env.dev file found in application folder.\e[0m"
fi

# Run common installation script
if [ -f "./install/helpers/common.sh" ]; then
    echo -e "\e[33mRunning common installation script...\e[0m"
    ./install/helpers/common.sh
fi