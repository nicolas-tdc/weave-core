#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mCloning weave application...\e[0m"

# Source clone includes helpers
if [ -f "./scripts/helpers/includes-clone.sh" ]; then
    source ./scripts/helpers/includes-clone.sh
else
    echo -e "\e[31mCannot find 'includes-clone' file! Exiting...\e[0m"
    exit 1
fi

# Required packages installation
install_packages \
    git

# Application configuration
echo -e "\e[33mConfiguring application...\e[0m"
configure_setup_type
configure_repository
configure_name
configure_path
echo -e "\e[32mCommon configuration successful.\e[0m"

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
select_remote_branch "$APP_REPOSITORY"
git clone --single-branch --branch "$SELECTED_BRANCH" "$APP_REPOSITORY" "$APP_NAME"
echo -e "\e[32mCloned repository successfully.\e[0m"

echo -e "\e[32mWeave application cloned.\e[0m"
