#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mCreating weave application...\e[0m"

# Source common configuration helpers
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
echo -e "\e[33mInstalling weave required packages...\e[0m"
install_packages "git"

# Application configuration
echo -e "\e[33mConfiguring application...\e[0m"

# Configure common
configure_setup_type
configure_repository
configure_name
configure_path
echo -e "\e[32mCommon configuration successful.\e[0m"

# Create directory
create_application_directory
echo -e "\e[32mApplication directory created successfully.\e[0m"

# Configure initial
configure_service_directory
configure_main_branch
configure_staging_branch
configure_dev_branch
configure_environment_files
echo -e "\e[32mInitial configuration successful.\e[0m"

copy_default_files
echo -e "\e[32mDefault weave files copied successfully.\e[0m"

# Add and configure services
echo -e "\e[33mAdding and configuring services...\e[0m"
authenticate_ssh_agent
configure_services "$APP_PATH/$APP_NAME/$SERVICES_DIRECTORY"

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

# @TODO : Remove comments after testing
# initialize_application_repository \
#     $APP_REPOSITORY \
#     "$MAIN_BRANCH,$STAGING_BRANCH,$DEV_BRANCH"

echo -e "\e[32mWeave application created.\e[0m"
