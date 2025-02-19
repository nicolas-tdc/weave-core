#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mInstall application\e[0m"

# Setup local environment
if [ -f "./helpers/local-setup.sh" ]; then
    echo -e "\e[33mSetting up local environment...\e[0m"
    source ./helpers/local-setup.sh
fi

# Setup app environment
if [ -f "./helpers/app-setup.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app-setup.sh
fi

# Run git setup script
if [ -f "./helpers/git-setup.sh" ]; then
    echo -e "\e[33mSetting up git...\e[0m"
    source ./helpers/git-setup.sh
fi

# Add services
if [ -f "./helpers/add-services.sh" ]; then
    echo -e "\e[33mAdding services...\e[0m"
    ./helpers/add-services.sh
fi

# Set permissions
if [ -f "./helpers/set-permissions.sh" ]; then
    echo -e "\e[33mSetting up permissions...\e[0m"
    ./helpers/set-permissions.sh "$APP_NAME" 755
fi

# Application versioning
if [ -f "./helpers/app-versioning.sh" ]; then
    echo -e "\e[33mApplication versioning...\e[0m"
    ./helpers/app-versioning.sh
fi