#!/bin/bash

# Exit immediately if a command fails
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

echo -e "\e[33mTrying to update application '$APP_NAME'...\e[0m"

if [ -z "$1" ]; then
    echo -e "\e[33mTrying to update application '$APP_NAME'...\e[0m"
    execute_command_on_all_services $SERVICES_DIRECTORY "update"
else
    service_name=$1
    echo -e "\e[33mTrying to update service '$service_name'...\e[0m"
    execute_command_on_specific_service $SERVICES_DIRECTORY "update" $service_name
fi

echo -e "\e[32mApplication '$APP_NAME' updated.\e[0m"
