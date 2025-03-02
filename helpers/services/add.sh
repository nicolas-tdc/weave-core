#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Add services
while true; do
    # Service name input
    echo -e "Enter your service's name - Enter 'stop' to end (default: 'service'): \c"
    read SERVICE_NAME
    # End add services
    if [ "$SERVICE_NAME" == "stop" ]; then
        break;
    fi
    # Check if service name already used
    if [ -d "./$APP_NAME/$SERVICE_NAME" ]; then
        echo -e "\e[31mService name already used.\e[0m"
        continue;
    fi
    SERVICE_NAME=${SERVICE_NAME:-service}
    export SERVICE_NAME

    # Service repository input
    while true; do
        echo -e "Enter your service's repository SSH address to clone: \c"
        read CLONE_REPOSITORY
        # Check for valid repository input
        if [[ "$CLONE_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
            break;
        else
            echo -e "\e]31mInvalid SSH Git clone URL.\e[0m"
        fi
    done

    # Service branch name input
    echo -e "\e[33mEnter your target branch name to clone from (default: 'main'): \c\e[0m"
    read CLONE_BRANCH
    CLONE_BRANCH=${CLONE_BRANCH:-main}

    # Clone repository
    echo -e "\e[33mCloning repository...\e[0m"
    git clone --single-branch --branch "$CLONE_BRANCH" "$CLONE_REPOSITORY" "$APP_NAME/$SERVICE_NAME"

    # Check if service contains necessary files
    if ! [ -f "./$APP_NAME/$SERVICE_NAME/.env.dist" ] || ! [ -f "./$APP_NAME/$SERVICE_NAME/docker-compose.yml" ]; then
        echo -e "\e[31mInvalid service: missing .env.dist or docker-compose.yml file!e\0m]"
        echo -e "\e[33mRemoving service...e\0m]"
        rm -rf "./$APP_NAME/$SERVICE_NAME"
        continue;
    fi

    format_docker() {
        # Format service environment variables and docker-compose file
        if [ -f "./helpers/services/format-docker-compose.sh" ]; then
            echo -e "\e[33mFormatting service's docker-compose.yml file...\e[0m"
            ./helpers/services/format-docker-compose.sh
        fi
    }

    initialize_service() {
        # Initialize service
        if [ -f "./helpers/services/init.sh" ]; then
            echo -e "\e[33mInitializing service...\e[0m"
            ./helpers/services/init.sh
        fi
    }

    format_docker &
    initialize_service &
    wait
done