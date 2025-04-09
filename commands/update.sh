#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to update the application and its services.

# Source docker helpers
if [ -f "./weave-core/helpers/docker.sh" ]; then
    source ./weave-core/helpers/docker.sh
else
    echo -e "\e[31mCannot find 'docker' file. Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave-core/helpers/services.sh" ]; then
    source ./weave-core/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file. Exiting...\e[0m"
    exit 1
fi

if [ -z "$1" ]; then
    # Execute the update command on all services
    echo -e "\e[33mTrying to update application '$APP_NAME'...\e[0m"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "update"

    echo -e "\e[33mApplication '$APP_NAME' updated successfully.\e[0m"
else
    # Execute the update command on a specific service
    service_name=$1
    echo -e "\e[33mTrying to update service '$service_name'...\e[0m"

    execute_command_on_specific_service \
        $SERVICES_DIRECTORY \
        "update" \
        $service_name

    echo -e "\e[33mService '$service_name' updated successfully...\e[0m"
fi
