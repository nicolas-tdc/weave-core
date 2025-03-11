#!/bin/bash

# Exit immediately if a command fails
set -e

# Stopping existing containers
echo -e "\e[33mStopping existing containers...\e[0m"
docker-compose down

# Cleaning up unused Docker images
echo -e "\e[33mCleaning up unused Docker images...\e[0m"
docker system prune -af
