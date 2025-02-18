#!/bin/bash

# Exit immediately if a command fails
set -e

# Remove the BACKUP_TIMEGAP entry from the .env file
if [ -f .env ]; then
  sed -i '/BACKUP_TIMEGAP/d' .env
fi

# Remove the cron job for the backup script
crontab -l | grep -v 'backup_task.sh' | crontab -

echo "Backup cron job disabled and BACKUP_TIMEGAP removed from .env."
