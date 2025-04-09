#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to start the application and its services.

# Source services helpers
if [ -f "./weave-core/helpers/services.sh" ]; then
    source ./weave-core/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' helper file. Exiting...\e[0m"
    exit 1
fi

if [ -z "$1" ]; then
    # Execute the start command on all services
    echo -e "\e[33mTrying to start application '$APP_NAME'...\e[0m"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "start"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "log"

    echo -e "\e[33mApplication '$APP_NAME' started successfully.\e[0m"
else
    # Execute the start command on a specific service
    service_name=$1
    echo -e "\e[33mTrying to start service '$service_name'...\e[0m"

    execute_command_on_specific_service \
        $SERVICES_DIRECTORY \
        "start" \
        $service_name

    execute_command_on_specific_service\
        $SERVICES_DIRECTORY \
        "log" \
        $service_name

    echo -e "\e[33mService '$service_name' started successfully...\e[0m"
fi
