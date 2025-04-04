#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source docker helpers
if [ -f "./weave/helpers/docker.sh" ]; then
    source ./weave/helpers/docker.sh
else
    echo -e "\e[31mCannot find 'docker' file! Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

echo -e "\e[33mTrying to add services to application '$APP_NAME'...\e[0m"

# Add and configure services
echo -e "\e[33mAdding and configuring services...\e[0m"
# weave services
configure_weave_services "$SERVICES_DIRECTORY" "./weave/available-services"

# Merge gitignore files
echo -e "\e[33mMerging gitignore files...\e[0m"
merge_gitignore_files \
    "$SERVICES_DIRECTORY" \
    ".gitignore"

echo -e "\e[32mDone adding services to '$APP_NAME'.\e[0m"
