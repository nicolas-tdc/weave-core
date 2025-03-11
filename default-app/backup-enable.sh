#!/bin/bash

# Exit immediately if a command fails
set -e

# Ask for the backup time gap (in seconds)
echo "Please enter the backup time gap in seconds:"
read BACKUP_TIMEGAP

# Check if cron job already exists, and remove it if necessary
sudo crontab -l | grep -v 'backup_task.sh' | crontab -

# Add cron job to run backup_task.sh every hour, passing the BACKUP_TIMEGAP from .env
sudo (crontab -l; echo "0 * * * * ./backup_task.sh \$BACKUP_TIMEGAP") | crontab -

echo -e "\e[31mBackup time gap set to $BACKUP_TIMEGAP seconds and cron job created.\e[0m"
