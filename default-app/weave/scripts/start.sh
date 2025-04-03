#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

set_application_environment

# Required packages installation
install_packages \
    docker \
    docker-compose

if [ -z "$1" ]; then
    echo -e "\e[33mTrying to start application '$APP_NAME'...\e[0m"
    execute_command_on_all_services $SERVICES_DIRECTORY "start"
    execute_command_on_all_services $SERVICES_DIRECTORY "log"
else
    service_name=$1
    echo -e "\e[33mTrying to start service '$service_name'...\e[0m"
    execute_command_on_specific_service $SERVICES_DIRECTORY "start" $service_name
    execute_command_on_specific_service $SERVICES_DIRECTORY "log" $service_name
fi

echo -e "\e[32mApplication '$APP_NAME' started.\e[0m"
