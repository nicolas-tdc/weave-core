#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Service branch name input
[ $APP_ENV == "dev" ] && DEFAULT_BRANCH=$DEV_BRANCH || DEFAULT_BRANCH=$MAIN_BRANCH
echo -e "\e[33mEnter your target branch name to clone from (default: '$DEFAULT_BRANCH'): \c\e[0m"
read CLONE_BRANCH
CLONE_BRANCH=${CLONE_BRANCH:-"$DEFAULT_BRANCH"}

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$CLONE_BRANCH" "$APP_REPOSITORY" "$APP_NAME"
