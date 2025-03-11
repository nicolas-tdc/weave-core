#!/bin/bash

# Exit immediately if a command exits with a non-zero status
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

# Run git auth script
if [ -f "./helpers/git/ssh-agent.sh" ]; then
    echo -e "\e[33mGit authentication...\e[0m"
    source ./helpers/git/ssh-agent.sh
fi

# Configure services
if [ -f "./helpers/services/config.sh" ]; then
    echo -e "\e[33mConfiguring services...\e[0m"
    ./helpers/services/config.sh
fi

# Join .gitignore files
if [ -f "./helpers/git/merge-ignores.sh" ]; then
    echo -e "\e[33mMerging .gitignore files...\e[0m"
    ./helpers/git/merge-ignores.sh
fi
