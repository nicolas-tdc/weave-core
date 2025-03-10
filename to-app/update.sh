#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables
if [ -f "./helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/set-environment.sh
fi

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./helpers/install-required.sh
fi

# @todo: Update application here

# git pull

# update service specific ? db ? 
