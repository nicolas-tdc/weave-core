#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/set-environment.sh $1
fi

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./helpers/install-required.sh
fi

# Execute service specific scripts
if [ -f "./helpers/services/execute-specific.sh" ]; then
    ./helpers/services/execute-specific.sh $(basename "$0")
fi

# Remove app docker network
if [ -f "./helpers/docker/remove-network.sh" ]; then
    echo -e "\e[33mRemoving application docker network...\e[0m"
    ./helpers/docker/remove-network.sh
fi

echo -e "\e[32mApplication stopped!\e[0m"