#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Format docker-compose file

COMPOSE_FILE="$APP_NAME/$SERVICE_NAME/docker-compose.yml"
NETWORK_NAME="${APP_NAME}_network"
CONTAINER_NAME="${APP_NAME}_${SERVICE_NAME}"
ENV_FILE="../../.env.common"

# Ensure the additional env file is added
if ! grep -q "$ENV_FILE" "$COMPOSE_FILE"; then
  sed -i '/env_file:/a\ \ \ \ \ \ - '"$ENV_FILE" "$COMPOSE_FILE"
fi

# Ensure each service has the network assigned and container_name is set dynamically
awk -v container_name="$CONTAINER_NAME" -v net="$NETWORK_NAME" '
  BEGIN { inside_service=0 }
  /^services:/ { print; next }
  /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/ {
      # Capture the service name properly
      service_name = substr($0, match($0, /^[[:space:]]{2}([a-zA-Z0-9_-]+):/), RLENGTH)
      # Remove leading spaces and trailing colon
      gsub(/^[[:space:]]+/, "", service_name)
      gsub(/:$/, "", service_name)
      
      # Prepend ${CONTAINER_NAME}_ to the service name
      modified_service_name = container_name "_" service_name
      print "  " modified_service_name ":"
      inside_service=1
      next
  }
  inside_service && /^[[:space:]]{4}container_name:/ { next }  # Remove existing container_name
  inside_service && /^[[:space:]]{4}networks:/ { inside_service=0 }
  inside_service && /^[[:space:]]{2}[a-zA-Z0-9_-]+:/ {
      inside_service=0
      # Now append service_name to container_name
      print "    container_name: " container_name "_" service_name
      print "    networks:\n      - " net
      print
  }
  { print }
  END { if (inside_service) print "    container_name: " container_name "_" service_name "\n    networks:\n      - " net }
' "$COMPOSE_FILE" > tmpfile && mv tmpfile "$COMPOSE_FILE"

# Ensure the networks section exists at the bottom
if ! grep -q "^networks:" "$COMPOSE_FILE"; then
  echo -e "\nnetworks:\n  $NETWORK_NAME:\n    external: true" >> "$COMPOSE_FILE"
elif ! grep -q "$NETWORK_NAME" "$COMPOSE_FILE"; then
  echo -e "  $NETWORK_NAME:\n    external: true" >> "$COMPOSE_FILE"
fi