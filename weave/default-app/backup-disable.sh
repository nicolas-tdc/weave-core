#!/bin/bash

# Exit immediately if a command fails
set -e

# Remove the cron job for the backup script
sudo crontab -l | grep -v 'backup_task.sh' | crontab -

echo "Backup cron job disabled and BACKUP_TIMEGAP removed from .env."
