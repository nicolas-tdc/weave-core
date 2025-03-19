#!/bin/bash

current_dir=$(pwd)

# Exectue from application root
cd "$(dirname "$0")"

case "$1" in
  start) ./weave/scripts/start.sh $2;;
  stop) ./weave/scripts/stop.sh $2;;
  install) ./weave/scripts/install.sh $2;;
  update) ./weave/scripts/update.sh $2;;
  backup-task) ./weave/scripts/backup-task.sh $2;;
esac

cd "$current_dir"
