#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to disable the backup cron job for the application.

echo -e "\e[33mTrying to disable backup cron job application '$APP_NAME'...\e[0m"

echo "e\33mTrying to disable backup cron job for application '$APP_NAME'...\e[0m"

# Remove the cron job for the backup script
sudo crontab -l | grep -v 'backup.sh' | crontab -

echo -e "\e[32mDisabled backup cron job for '$APP_NAME'.\e[0m"
