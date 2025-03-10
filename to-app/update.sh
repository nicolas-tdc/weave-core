#!/bin/bash

# Exit immediately if a command fails
set -e

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

# @todo: git pull ?

# Execute service specific scripts
if [ -f "./helpers/docker/execute-specific.sh" ]; then
    echo -e "\e[33mExecuting service specific scripts...\e[0m"
    ./helpers/services/execute-specific.sh $(basename "$0")
fi
x