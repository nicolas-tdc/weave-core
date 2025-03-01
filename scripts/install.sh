#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mInstall application\e[0m"

if [ -f "./helpers/setup-local.sh" ]; then
    echo -e "\e[33mSetting up local environment...\e[0m"
    source ./helpers/setup-local.sh
fi

if [ -f "./helpers/app/env-setup.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app/env-setup.sh
fi

# Run git clone script
if [ -f "./helpers/git/clone.sh" ]; then
    echo -e "\e[33mGit cloning for project clone...\e[0m"
    [ $APP_ENV == "dev" ] && DEFAULT_BRANCH=$DEV_BRANCH || DEFAULT_BRANCH=$MAIN_BRANCH
    ./helpers/git/clone.sh $APP_NAME $DEFAULT_BRANCH
fi
