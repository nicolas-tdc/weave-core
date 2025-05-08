#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source git helpers
if [ -f "./weave-core/helpers/git.sh" ]; then
    source ./weave-core/helpers/git.sh
else
    echo -e "\e[31mCannot find 'git' helpers file. Exiting...\e[0m"
    exit 1
fi


echo -e "\e[33mTrying to remove a service to application '$APP_NAME'...\e[0m"

# Install service
echo -e "\e[33mRemoving service $SERVICE_NAME...\e[0m"

rm -rf "$SERVICES_DIRECTORY/$SERVICE_NAME"

echo -e "\e[33mService added successfully.\e[0m"

# Merge gitignore files
echo -e "\e[33mCleaning gitignore files...\e[0m"

# @todo remove lines containing "$SERVICE_NAME" from .gitignore
remove_service_from_gitignore \
    "$SERVICE_NAME" \
    ".gitignore"

echo -e "\e[33mGitignore file cleaned successfully.\e[0m"

echo -e "\e[32mAdded service successfully.\e[0m"