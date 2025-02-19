#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input main branch name
echo -e "Enter your git main branch name (default: 'main'): \c"
read MAIN_BRANCH
MAIN_BRANCH=${MAIN_BRANCH:-main}

# Input  branch name
echo -e "Enter your development branch name (default: 'devel'): \c"
read BRANCH
BRANCH=${BRANCH:-devel}
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> .env

echo -e "\e[33mInit, commit and push app with services to repository...\e[0m"
# Commit and push app with services to repository
cd "$APP_NAME"
git init --initial-branch="$MAIN_BRANCH"
git add .
git commit -m "Initial commit $APP_NAME"
git remote add origin "$APP_REPOSITORY"
git push -u origin "$MAIN_BRANCH"
git checkout -b "$BRANCH"
git push -u origin "$MAIN_BRANCH:$BRANCH"

pkill ssh-agent