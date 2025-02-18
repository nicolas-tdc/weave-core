#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mInitializing application...\e[0m"

# Application name input
echo -e "Enter application name (default: 'app'): \c"
read APP_ENV
APP_NAME=${APP_NAME:-app}
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
    echo -e "Enter your environment init|dev|prod (default: 'dev'): \c"
    read APP_ENV
    APP_ENV=${APP_ENV:-dev}
    APP_ENV=$([ "$APP_ENV" == "hello" ] && echo "dev" || echo "$APP_ENV")
    # Check for valid environment input
    if [ $APP_ENV == "dev"  ] || [ $APP_ENV == "init"  ] || [ $APP_ENV == "prod" ]; then
        break;
    else
        echo -e "\e[31mInvalid input. Please choose a valid environment.\e[0m"
    fi
done
# Add to .env file
echo "export APP_ENV=\"$APP_ENV\"" >> .env
export APP_ENV

GIT_SSH_REGEX="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"
# Application repostiory input
while true; do
    echo -e "Enter your application repository SSH clone URL: \c"
    read APP_REPOSITORY
    # Check for valid repository input
    if [[ "$APP_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
        break;
    else
        echo "Invalid SSH Git clone URL."
    fi
done
# Add to .env file
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> .env
export APP_REPOSITORY

# Starter kit repository input
if [ $APP_ENV == "init" ]; then
    while true; do
        echo -e "Enter your starter kit repository SSH clone adress: \c"
        read SK_REPOSITORY
        # Check for valid repository input
        if [[ "$SK_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
            break;
        else
            echo "Invalid SSH Git clone URL."
        fi
    done
    # Add to .env file
    export SK_REPOSITORY

    echo -e "Enter your starter kit branch name (default: 'main'): \c"
    read SK_BRANCH_NAME
    SK_BRANCH_NAME=${SK_BRANCH_NAME:-main}
    export SK_BRANCH_NAME
fi

# Create app directory
echo -e "\e[33mCreating application directory...\e[0m"]
mkdir -p $APP_NAME

apt update

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling git..."
    apt install -y git
fi

if [ $APP_ENV == "init" ]; then
    if [ -f "./install/initial.sh" ]; then
        echo -e "\e[33mSetting up initial environment...\e[0m"
        ./install/initial.sh
    fi
elif [ $APP_ENV == "dev" ]; then
    if [ -f "./install/dev.sh" ]; then
        echo -e "\e[33mSetting up development environment...\e[0m"
        ./install/dev.sh
    fi
elif [ $APP_ENV == "prod" ]; then
    if [ -f "./install/prod.sh" ]; then
        echo -e "\e[33mSetting up production environment...\e[0m"
        ./install/prod.sh
    fi
fi