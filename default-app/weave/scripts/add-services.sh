#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source common configuration helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

# Source common configuration helpers
if [ -f "./weave/helpers/docker.sh" ]; then
    source ./weave/helpers/docker.sh
else
    echo -e "\e[31mCannot find 'docker' file! Exiting...\e[0m"
    exit 1
fi

# Source common configuration helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

set_application_environment $1

echo -e "\e[33mTrying to add services to application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

install_packages \
    git

# Add and configure services
echo -e "\e[33mAdding and configuring services...\e[0m"
authenticate_ssh_agent
configure_services "$SERVICES_DIRECTORY"

echo -e "\e[33mMerging gitignore files...\e[0m"
merge_gitignore_files \
    "$SERVICES_DIRECTORY" \
    ".gitignore"

echo -e "\e[32mDone adding services to '$APP_NAME' in '$APP_ENV' environment.\e[0m"
