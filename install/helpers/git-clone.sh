#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$BRANCH" "$APP_REPOSITORY" "$APP_NAME"