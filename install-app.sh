#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application installation!\e[0m"

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    source ./helpers/install-required.sh
fi

# Common application configurations
if [ -f "./helpers/config-common.sh" ]; then
    source ./helpers/config-common.sh
fi

# Initial application configurations
if [ -f "./helpers/config-install.sh" ]; then
    source ./helpers/config-install.sh
fi

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$BRANCH" "$APP_REPOSITORY" "$APP_NAME"

cd $APP_NAME

# Execute service specific install scripts
if [ -f "./helpers/services/execute-specific.sh" ]; then
    ./helpers/services/execute-specific.sh "install.sh"
fi

echo -e "\e[32mApplication installed!\e[0m"
