#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mConfiguring services...\e[0m"

# Add services
while true; do
    # Service repository input
    while true; do
        echo -e "Enter your service's repository SSH address or 'done' to end services configuration: \c"
        read SERVICE_REPOSITORY
        # Check for valid repository input
        if [ "$SERVICE_REPOSITORY" == "done" ] || [[ "$SERVICE_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
            break;
        else
            echo -e "\e]31mInvalid service repository input.\e[0m"
        fi
    done

    # End services configuration
    if [ "$SERVICE_REPOSITORY" == "done" ]; then
        break;
    fi

    # Service name input
    REPOSITORY_NAME=$(basename "$SERVICE_REPOSITORY" .git)
    echo -e "Enter your service's name (default: '$REPOSITORY_NAME'): \c"
    read SERVICE_NAME
    SERVICE_NAME=${SERVICE_NAME:-$REPOSITORY_NAME}
    # Check if service name already used
    if [ -d "./$SERVICES_DIR/$SERVICE_NAME" ]; then
        echo -e "\e[31mService name already used.\e[0m"
        continue;
    fi
    SERVICE_NAME=${SERVICE_NAME:-service}
    export SERVICE_NAME

    # Service branch name input
    echo -e "\e[33mEnter your target branch name to clone from (default: 'main'): \c\e[0m"
    read CLONE_BRANCH
    CLONE_BRANCH=${CLONE_BRANCH:-main}

    # Clone repository
    echo -e "\e[33mCloning repository...\e[0m"
    git clone --single-branch --branch "$CLONE_BRANCH" "$SERVICE_REPOSITORY" "./$SERVICES_DIR/$SERVICE_NAME"

    # Remove git remote
    rm -rf "./$SERVICES_DIR/$SERVICE_NAME/.git"

    # Copy default service files to service directory
    if [ -d "./default-service" ] && [ -d "./$SERVICES_DIR/$SERVICE_NAME" ]; then
        sudo cp -r ./default-service/* "./$SERVICES_DIR/$SERVICE_NAME"
        sudo chmod -R 755 "./$SERVICES_DIR/$SERVICE_NAME"
    fi

    echo -e "\e[32mService $SERVICE_NAME added successfully!\e[0m"
done