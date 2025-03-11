#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mConfiguring application initialization...\e[0m"

# Input prod main branch name
echo -e "Enter your services' directory name (default: 'services'): \c"
read_default "SERVICES_DIR" "services"
mkdir -p "$APP_PATH/$APP_NAME/$SERVICES_DIR"
export SERVICES_DIR

# Input prod main branch name
echo -e "Enter your main production branch name (default: 'main'): \c"
read_default "MAIN_BRANCH" "main"
export MAIN_BRANCH

# Input staging branch name
echo -e "Enter your staging branch name (default: 'staging'): \c"
read_default "STAGING_BRANCH" "staging"
export STAGING_BRANCH

# Input dev branch name
echo -e "Enter your development branch name (default: 'develop'): \c"
read_default "DEV_BRANCH" "develop"
export DEV_BRANCH

# Environment files names
DEV_ENV_FILE="$APP_PATH/$APP_NAME/.env.dev"
STAGING_ENV_FILE="$APP_PATH/$APP_NAME/.env.staging"
PROD_ENV_FILE="$APP_PATH/$APP_NAME/.env.prod"

# Add variables to .env file
# App repository
echo "export SERVICES_DIR=\"$SERVICES_DIR\"" > $DEV_ENV_FILE
echo "export SERVICES_DIR=\"$SERVICES_DIR\"" > $STAGING_ENV_FILE
echo "export SERVICES_DIR=\"$SERVICES_DIR\"" > $PROD_ENV_FILE
# App repository
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $DEV_ENV_FILE
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $STAGING_ENV_FILE
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $PROD_ENV_FILE
# Git branches
echo "export BRANCH=\"$MAIN_BRANCH\"" >> $PROD_ENV_FILE
echo "export BRANCH=\"$STAGING_BRANCH\"" >> $STAGING_ENV_FILE
echo "export BRANCH=\"$DEV_BRANCH\"" >> $DEV_ENV_FILE