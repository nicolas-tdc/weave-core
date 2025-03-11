#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./weave/helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./weave/helpers/set-environment.sh $1
fi

# Install required packages
if [ -f "./weave/helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./weave/helpers/install-required.sh
fi

# @todo: git pull ?

# Execute service specific scripts
if [ -f "./weave/helpers/services/execute-specific.sh" ]; then
    ./weave/helpers/services/execute-specific.sh $(basename "$0")
fi
