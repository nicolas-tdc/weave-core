#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

# Remove git remote
rm -rf "$APP_NAME/$SERVICE_NAME/.git"
