#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application initialization!\e[0m"

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    source ./helpers/install-required.sh
fi

# Common application configurations
if [ -f "./helpers/config-common.sh" ]; then
    source ./helpers/config-common.sh
fi

# Create app directory
echo -e "\e[33mCreating application directory...\e[0m"
mkdir -p "$APP_PATH/$APP_NAME"

# Initial application configurations
if [ -f "./helpers/config-init.sh" ]; then
    source ./helpers/config-init.sh
fi

# Copy default application files
if [ -d "./default-app" ] && [ -d "$APP_PATH/$APP_NAME" ]; then
    echo -e "\e[33mCopying default application files...\e[0m"
    sudo cp -r ./default-app/* "$APP_PATH/$APP_NAME"
fi

# Move to app directory
cd "$APP_PATH/$APP_NAME"

# Run git auth script
if [ -f "./helpers/git/ssh-agent.sh" ]; then
    source ./helpers/git/ssh-agent.sh
fi

# Configure services
if [ -f "./helpers/services/config.sh" ]; then
    ./helpers/services/config.sh
fi

# Join .gitignore files
if [ -f "./helpers/git/merge-ignores.sh" ]; then
    ./helpers/git/merge-ignores.sh
fi

sudo chmod -R 755 ./
sudo chown -R $USER:$USER ./

# # Initialize git repository and create defined branches
echo -e "\e[33mInitializing and pushing application with services to repository...\e[0m"
# Commit and push app with services to repository
git init --initial-branch="$MAIN_BRANCH"
git add .
git commit -m "Initial commit $APP_NAME"
git remote add origin "$APP_REPOSITORY"
# Main branch
git push -u origin "$MAIN_BRANCH"
# Staging branch
git checkout -b "$STAGING_BRANCH"
git push -u origin "$MAIN_BRANCH:$STAGING_BRANCH"   
# Development branch
git checkout "$MAIN_BRANCH"
git checkout -b "$DEV_BRANCH"
git push -u origin "$MAIN_BRANCH:$DEV_BRANCH"

echo -e "\e[32mApplication initialized successfully!\e[0m"
