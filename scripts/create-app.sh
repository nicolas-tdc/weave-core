#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to create a weave application.

echo -e "\e[33mTrying to create weave application...\e[0m"

# Source initial includes helpers
if [ -f "./scripts/helpers/includes-create.sh" ]; then
    source ./scripts/helpers/includes-create.sh
else
    echo -e "\e[31mCannot find 'includes-create' file! Exiting...\e[0m"
    exit 1
fi

# Check default files
echo -e "\e[33mChecking weave default files...\e[0m"
check_default_files
echo -e "\e[32mweave default files found.\e[0m"

# Required packages installation
echo -e "\e[33mInstalling required packages...\e[0m"
install_packages \
    git
echo -e "\e[32mAll packages are installed.\e[0m"

# Application configuration
echo -e "\e[33mConfiguring application...\e[0m"
# Defines APP_NAME
configure_name
# Defines APP_PARENT_PATH
configure_path

# Create directory
echo -e "\e[33mTrying to create application directory...\e[0m"
create_application_directory "$APP_PARENT_PATH/$APP_NAME"
echo -e "\e[32mApplication directory created successfully.\e[0m"

echo -e "\e[33mTrying to create services directory...\e[0m"
# Defines SERVICES_DIRECTORY
create_services_directory "$APP_PARENT_PATH/$APP_NAME"
echo -e "\e[32mServices directory created successfully.\e[0m"

echo -e "\e[33mTrying to create application environment file...\e[0m"
configure_environment_file "$APP_PARENT_PATH/$APP_NAME" "$APP_NAME" "$SERVICES_DIRECTORY"
echo -e "\e[32mEnvironment file created successfully.\e[0m"

echo -e "\e[32mInitial application configuration successful.\e[0m"

echo -e "\e[33mTrying to copy weave default files...\e[0m"
copy_default_files
echo -e "\e[32mDefault weave files copied successfully.\e[0m"

# Add and configure services
echo -e "\e[33mAdding and configuring services...\e[0m"
configure_weave_services "$APP_PARENT_PATH/$APP_NAME/$SERVICES_DIRECTORY" "./available-services"
echo -e "\e[32mServices added successfully.\e[0m"

# Move to app directory
echo -e "\e[33mMoving to application directory...\e[0m"
cd "$APP_PARENT_PATH/$APP_NAME"

echo -e "\e[33mTrying to merge gitignore files...\e[0m"
merge_gitignore_files \
    "$SERVICES_DIRECTORY" \
    ".gitignore"
echo -e "\e[32mGitignore files merged successfully.\e[0m"

# Set permissions
echo -e "\e[33mTrying to set permissions...\e[0m"
sudo chmod -R 755 ./
sudo chown -R $USER:$USER ./
echo -e "\e[32mPermissions set successfully.\e[0m"

echo -e "\e[32mweave application created.\e[0m"
