#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Run service's specific initialization script
cd "$APP_NAME/$SERVICE_NAME"

# Copy environment variables
cp .env.dist .env.dev
cp .env.dist .env.prod

# @todo : ? Cleanup service git
rm -rf "./.git"

# Set service's specific scripts permissions
if [ -d "./scripts" ]; then
    chmod -R 755 "./scripts"
fi

# Service's specific script
if [ -d "./scripts" ] && [ -f "./scripts/init.sh" ]; then
    echo -e "\e[33mRunning service specific initialization script...\e[0m"
    "./scripts/init.sh"
fi