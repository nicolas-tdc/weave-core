#!/bin/bash

# Exit immediately if a command exits with a non-zero status
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

# Run git auth script
if [ -f "./weave/helpers/git/ssh-agent.sh" ]; then
    echo -e "\e[33mGit authentication...\e[0m"
    source ./weave/helpers/git/ssh-agent.sh
fi

# Configure services
if [ -f "./weave/helpers/services/config.sh" ]; then
    echo -e "\e[33mConfiguring services...\e[0m"
    ./weave/helpers/services/config.sh
fi

# Join .gitignore files
if [ -f "./weave/helpers/git/merge-ignores.sh" ]; then
    echo -e "\e[33mMerging .gitignore files...\e[0m"
    ./weave/helpers/git/merge-ignores.sh
fi
