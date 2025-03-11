#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./weave/helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./weave/helpers/set-environment.sh $1
fi

echo -e "\e[33mTrying to run application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

# Install required packages
if [ -f "./weave/helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./weave/helpers/install-required.sh
fi

# Create app docker network
if [ -f "./weave/helpers/docker/create-network.sh" ]; then
    echo -e "\e[33mCreating application docker network...\e[0m"
    ./weave/helpers/docker/create-network.sh
fi

# Execute service specific scripts
if [ -f "./weave/helpers/services/execute-specific.sh" ]; then
    ./weave/helpers/services/execute-specific.sh $(basename "$0")
    ./weave/helpers/services/execute-specific.sh "weave/helpers/log-available-ports.sh"
fi

echo -e "\e[32mApplication '$APP_NAME' running in '$APP_ENV' environment!\e[0m"
