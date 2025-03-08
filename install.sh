#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application installation!\e[0m"

# Setup app environment
if [ -f "./helpers/app/read-environment.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app/read-environment.sh
fi

# Clone repository
if [ -f "./helpers/app/clone-repository.sh" ]; then
    echo -e "\e[33mCloning repository...\e[0m"
    source ./helpers/app/clone-repository.sh
fi
