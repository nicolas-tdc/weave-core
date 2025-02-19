#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Application name input
echo -e "Enter application name (default: 'app'): \c"
read APP_NAME
APP_NAME=${APP_NAME:-app}
# Create app directory
echo -e "\e[33mCreating application directory...\e[0m"
mkdir -p $APP_NAME
# Create and add to .env
echo "export APP_NAME=\"$APP_NAME\"" > .env
# Add to .gitignore file
grep -w "^app$" .gitignore
if [ $? == 1 ]; then
    echo "$APP_NAME" >> .gitignore
fi

export APP_NAME

# Application environment input
while true; do
    echo -e "Enter your environment dev|prod (default: 'dev'): \c"
    read APP_ENV
    APP_ENV=${APP_ENV:-dev}
    # Check for valid environment input
    if [ $APP_ENV == "dev"  ] || [ $APP_ENV == "prod" ]; then
        break;
    else
        echo -e "\e[31mInvalid input. Please choose a valid environment: dev|prod.\e[0m"
    fi
done
# Add to .env file
echo "export APP_ENV=\"$APP_ENV\"" >> .env

export APP_ENV

GIT_SSH_REGEX="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"
# Application repostiory input
while true; do
    echo -e "Enter your application new repository's SSH URL: \c"
    read APP_REPOSITORY
    # Check for valid repository input
    if [[ "$APP_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
        break;
    else
        echo "Invalid SSH Git URL."
    fi
done
# Add to .env file
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> .env

export APP_REPOSITORY
