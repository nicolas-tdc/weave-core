#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mInit, commit and push app with services to repository...\e[0m"
# Commit and push app with services to repository
cd "$APP_NAME"
git init --initial-branch="$MAIN_BRANCH"
git add .
git commit -m "Initial commit $APP_NAME"
git remote add origin "$APP_REPOSITORY"
git push -u origin "$MAIN_BRANCH"
git checkout -b "$DEV_BRANCH"
git push -u origin "$MAIN_BRANCH:$DEV_BRANCH"
