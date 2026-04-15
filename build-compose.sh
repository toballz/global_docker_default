#!/bin/bash

STAGE=${1:-dev}

if [ "$STAGE" = "dev" ]; then
  STAGE=$STAGE docker-compose -p global_apps -f docker compose.yml -f docker-compose-override.yml up -d --build
elif [ "$STAGE" = "prod" ]; then
  STAGE=$STAGE docker-compose -p global_apps -f docker compose.yml up -d
else
  echo "Usage: $0 [dev|prod]"
  exit 1
fi