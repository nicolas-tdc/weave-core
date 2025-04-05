#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to enable the backup cron job for the application.

echo -e "\e[33mTrying to enable backup cron job for application '$APP_NAME'...\e[0m"

# Ask for the backup time gap (in seconds)
echo -e "\e[94mPlease enter the backup time gap in seconds:\c\e[0m"
read backup_timegap

echo "e\33mTrying to enable backup cron job for application '$APP_NAME'...\e[0m"

# Check if cron job already exists, and remove it if necessary
sudo crontab -l | grep -v 'backup_task.sh' | crontab -

# Add cron job to run backup_task.sh every hour
(crontab -l 2>/dev/null; echo "0 * * * * ./backup_task.sh \$backup_timegap") | sudo crontab -

echo -e "\e[32mBackup time gap set to $backup_timegap seconds and cron job created for application '$APP_NAME'.\e[0m"
