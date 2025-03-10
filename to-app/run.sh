#!/bin/bash

# Exit immediately if a command fails
set -e

# @todo: necessary ? needs login logout so maybe indicate in documentation
# Check if user is in Docker group
if ! groups "$USER" | grep -q "\bdocker\b"; then
    # Add user to Docker group
    echo -e "\e[33mAdding user to Docker group...\e[0m"
    sudo usermod -aG docker $USER
fi

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./helpers/app/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/app/set-environment.sh $1
fi

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./helpers/install-required.sh
fi

# Create app docker network
if [ -f "./helpers/docker/create-network.sh" ]; then
    echo -e "\e[33mCreating application docker network...\e[0m"
    ./helpers/docker/create-network.sh
fi

# Execute service specific scripts
if [ -f "./helpers/docker/execute-specific.sh" ]; then
    echo -e "\e[33mExecuting service specific scripts...\e[0m"
    ./helpers/services/execute-specific.sh $(basename "$0")
fi

echo -e "\e[32mApplication started!\e[0m"
