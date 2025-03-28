#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mCreating weave application...\e[0m"

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

# Required packages installation
install_packages \
    git

# Application configuration
echo -e "\e[33mConfiguring application...\e[0m"
configure_name
configure_path
echo -e "\e[32mCommon configuration successful.\e[0m"

# Create directory
create_application_directory
echo -e "\e[32mApplication directory created successfully.\e[0m"

# Configure initial
create_service_directory
configure_environment_file
echo -e "\e[32mInitial configuration successful.\e[0m"

copy_default_files
echo -e "\e[32mDefault app weave files copied successfully.\e[0m"

# Add and configure services
echo -e "\e[33mAdding and configuring services...\e[0m"
configure_weave_services "$APP_PATH/$APP_NAME/$SERVICES_DIRECTORY" "./available-services"

# Move to app directory
echo -e "\e[33mMoving to application directory...\e[0m"
cd "$APP_PATH/$APP_NAME"

echo -e "\e[33mMerging gitignore files...\e[0m"
merge_gitignore_files \
    "$SERVICES_DIRECTORY" \
    ".gitignore"

# Set permissions
sudo chmod -R 755 ./
sudo chown -R $USER:$USER ./

echo -e "\e[32mWeave application created.\e[0m"
