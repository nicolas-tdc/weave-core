#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

DESTINATION_FOLDER=$1
DEFAULT_BRANCH=$2

# Service repository input
while true; do
    echo -e "Enter your repository's SSH clone adress: \c"
    read CLONE_REPOSITORY
    # Check for valid repository input
    if [[ "$CLONE_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
        break;
    else
        echo -e "\e]31mInvalid SSH Git clone URL.\e[0m"
    fi
done

# Service branch name input
echo -e "\e[33mEnter branch name to clone from (default: '$DEFAULT_BRANCH'): \c\e[0m"
read CLONE_BRANCH
CLONE_BRANCH=${CLONE_BRANCH:-"$DEFAULT_BRANCH"}

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$CLONE_BRANCH" "$CLONE_REPOSITORY" "$DESTINATION_FOLDER"
