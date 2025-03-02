#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mInstall application\e[0m"

if [ -f "./helpers/app/install-required.sh" ]; then
    echo -e "\e[33mSetting up local environment...\e[0m"
    source ./helpers/app/install-required.sh
fi

if [ -f "./helpers/app/read-env.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app/read-env.sh
fi

# Service branch name input
[ $APP_ENV == "dev" ] && DEFAULT_BRANCH=$DEV_BRANCH || DEFAULT_BRANCH=$MAIN_BRANCH
echo -e "\e[33mEnter your target branch name to clone from (default: '$DEFAULT_BRANCH'): \c\e[0m"
read CLONE_BRANCH
CLONE_BRANCH=${CLONE_BRANCH:-"$DEFAULT_BRANCH"}

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$CLONE_BRANCH" "$APP_REPOSITORY" "$APP_NAME"


# Loop through all services to execute init script
for SERVICE_DIR in "$APP_NAME"/*/; do
    if [ -d "$SERVICE_DIR" ]; then
        echo -e "\e[33mInitialize $SERVICE_DIR service...\e[0m"
        export SERVICE_NAME=$(basename "$SERVICE_DIR")
        if [ -f "./helpers/services/init.sh" ]; then
            ./helpers/services/init.sh
        fi
    fi
done
