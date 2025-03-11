#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/set-environment.sh $1
fi

echo -e "\e[33mTrying to run application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

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
if [ -f "./helpers/services/execute-specific.sh" ]; then
    ./helpers/services/execute-specific.sh $(basename "$0")
    ./helpers/services/execute-specific.sh "helpers/log-available-ports.sh"
fi

echo -e "\e[32mApplication '$APP_NAME' running in '$APP_ENV' environment!\e[0m"
