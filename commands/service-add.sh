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


echo -e "\e[33mTrying to add a service to application '$APP_NAME'...\e[0m"

install_service "$SERVICES_DIRECTORY" "weave.conf"
