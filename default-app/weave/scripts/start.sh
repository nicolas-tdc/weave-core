#!/bin/bash

# Exit immediately if a command fails
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

echo -e "\e[33mTrying to start application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

install_packages \
    git \
    docker \
    docker-network

create_network "$APP_NAME-main-network"

execute_services_specific_script $SERVICES_DIRECTORY "start.sh"
execute_services_specific_script $SERVICES_DIRECTORY "log-available-ports.sh"

echo -e "\e[32mApplication '$APP_NAME' started in '$APP_ENV' environment.\e[0m"
