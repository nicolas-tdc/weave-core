#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33m$SERVICE_NAME: Formatting docker-compose.yml file...\e[0m"

COMPOSE_FILE="docker-compose.yml"
NETWORK_NAME="${APP_NAME}_network"
CONTAINER_NAME="${APP_NAME}_${SERVICE_NAME}"
APP_ENV_FILE_PATH="../../.env"

# Ensure the application env file is added
if ! grep -q "$APP_ENV_FILE_PATH" "$COMPOSE_FILE"; then
  sed -i '/env_file:/a\ \ \ \ \ \ - '"$APP_ENV_FILE_PATH" "$COMPOSE_FILE"
fi

# Ensure each service has the network assigned and container_name is set
awk -v container_name="$CONTAINER_NAME" -v net="$NETWORK_NAME" '
  BEGIN { inside_service=0; inside_volumes=0; inside_networks=0; inside_service_volumes=0; service_name="" }

  /^services:/ { print; next }
  /^volumes:/ { print; inside_volumes=1; inside_service=0; next }
  /^networks:/ { print; inside_networks=1; inside_service=0; next }

  inside_volumes || inside_networks { 
      if (inside_volumes && /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/) { 
          gsub(/^[[:space:]]+/, "", $0)
          gsub(/:$/, "", $0)
          print "  " container_name "_" $0 ":"  # Rename global volumes
      } else { 
          print 
      }
      next 
  }

  /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/ {
      # Capture service name
      service_name = substr($0, match($0, /^[[:space:]]{2}([a-zA-Z0-9_-]+):/), RLENGTH)
      gsub(/^[[:space:]]+/, "", service_name)
      gsub(/:$/, "", service_name)

      # Modify service name and add container_name
      modified_service_name = container_name "_" service_name
      print "  " modified_service_name ":"
      
      # Ensure container_name and networks sections
      print "    container_name: " modified_service_name
      print "    networks:"
      print "      - " net
      inside_service=1
      next
  }

  inside_service && /^[[:space:]]{4}container_name:/ { next }  # Remove existing container_name
  inside_service && /^[[:space:]]{4}volumes:/ { inside_service_volumes=1; print; next }  # Detect service volumes
  inside_service_volumes && /^[[:space:]]{6}-[[:space:]]*([a-zA-Z0-9_-]+)/ {
      # Preserve indentation and rename volumes inside services correctly
      match($0, /^([[:space:]]*)- ([a-zA-Z0-9_-]+)/, groups)
      print groups[1] "- " container_name "_" groups[2]  # Maintain indentation
      next
  }
  inside_service_volumes && !/^[[:space:]]{6}-/ { inside_service_volumes=0 }

  # Modify the ME_CONFIG_MONGODB_SERVER value
  inside_service && /^[[:space:]]{6}ME_CONFIG_MONGODB_SERVER:/ {
      gsub(/mongo/, container_name "_mongo")
      print
      next
  }

  { print }

  END { if (inside_service) print "    container_name: " modified_service_name "\n    networks:\n      - " net }
' "$COMPOSE_FILE" > tmpfile && mv tmpfile "$COMPOSE_FILE"

# Ensure the networks section exists at the bottom
if ! grep -q "^networks:" "$COMPOSE_FILE"; then
  echo -e "\nnetworks:\n  $NETWORK_NAME:\n    external: true" >> "$COMPOSE_FILE"
elif ! grep -q "$NETWORK_NAME" "$COMPOSE_FILE"; then
  echo -e "  $NETWORK_NAME:\n    external: true" >> "$COMPOSE_FILE"
fi
