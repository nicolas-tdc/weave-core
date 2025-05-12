#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source git helpers
if [ -f "./weave-core/helpers/git.sh" ]; then
    source ./weave-core/helpers/git.sh
else
    echo -e "\e[31mCannot find 'git' helpers file. Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave-core/helpers/services/manage.sh" ]; then
    source ./weave-core/helpers/services/manage.sh
else
    echo -e "\e[31mCannot find services manage helper file. Exiting...\e[0m"
    exit 1
fi

if [ -z "$1" ]; then
    echo -e "\e[31mError: First argument is required.\e[0m"
    echo -e "\e[31musage: $0 <service_name>\e[0m"
    exit 1
fi

service_name=$1

echo -e "\e[33mTrying to remove a service to application '$APP_NAME'...\e[0m"

# Install service
echo -e "\e[33mRemoving service $service_name...\e[0m"

uninstall_service $SERVICES_DIRECTORY $service_name

echo -e "\e[32mAdded service successfully.\e[0m"