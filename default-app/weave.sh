#!/bin/bash

current_dir=$(pwd)

# Exectue from application root
cd "$(dirname "$0")"

case "$1" in
  start) ./weave/scripts/start.sh $2;;
  stop) ./weave/scripts/stop.sh $2;;
  update) ./weave/scripts/update.sh $2;;
  add-services) ./weave/scripts/add-services.sh $2;;
  backup-task) ./weave/scripts/backup-task.sh $2;;
  backup-enable) ./weave/scripts/backup-enable.sh $2;;
  backup-disable) ./weave/scripts/backup-disable.sh $2;;
#   run-service) 
#     if [ -z "$2" ]; then
#       echo "Usage: $0 run-service <service-name>"
#       exit 1
#     fi
#     SERVICE_NAME="$2"
#     if [ -f "$SERVICE_DIR/$SERVICE_NAME/run.sh" ]; then
#       ./"$SERVICE_DIR/$SERVICE_NAME/run.sh"
#     else
#       echo "Error: Service '$SERVICE_NAME' does not exist."
#       exit 1
#     fi
#     ;;
#   stop-service)
#     if [ -z "$2" ]; then
#       echo "Usage: $0 stop-service <service-name>"
#       exit 1
#     fi
#     SERVICE_NAME="$2"
#     if [ -f "$SERVICE_DIR/$SERVICE_NAME/stop.sh" ]; then
#       ./"$SERVICE_DIR/$SERVICE_NAME/stop.sh"
#     else
#       echo "Error: Service '$SERVICE_NAME' does not exist."
#       exit 1
#     fi
#     ;;
#   *)
#     echo "Usage: $0 {init|install|update|run-service|stop-service}"
#     exit 1
#     ;;
esac

cd "$current_dir"
