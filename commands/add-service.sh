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

# Source services helpers
if [ -f "./weave-core/helpers/services/setup.sh" ]; then
    source ./weave-core/helpers/services/setup.sh
else
    echo -e "\e[31mCannot find services setup helper file. Exiting...\e[0m"
    exit 1
fi


echo -e "\e[33mTrying to add a service to application '$APP_NAME'...\e[0m"

# Install service
echo -e "\e[33mAdding and configuring services...\e[0m"

install_service "$SERVICES_DIRECTORY" "./weave-core/available-services"

echo -e "\e[33mService added successfully.\e[0m"

# Merge gitignore files
echo -e "\e[33mMerging gitignore files...\e[0m"

merge_gitignore_files \
    "$SERVICES_DIRECTORY" \
    ".gitignore"

echo -e "\e[33mGitignore files merged successfully.\e[0m"

echo -e "\e[32mAdded service successfully.\e[0m"
