#!/bin/bash

# Check if a volume name and backup path are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <volume_name> <backup_path>"
  exit 1
fi

# Assign arguments to variables
VOLUME_NAME=$1
BACKUP_PATH=$2

# Verify that the backup path exists
if [ ! -d "$BACKUP_PATH" ]; then
  echo "Backup path does not exist: $BACKUP_PATH"
  exit 1
fi

# Run the backup command using a temporary Alpine container
docker run --rm -v $VOLUME_NAME:/volume -v $BACKUP_PATH:/backup alpine \
  tar czf /backup/${VOLUME_NAME}_$(date +\%F).tar.gz -C /volume .
  
# Check for successful execution
if [ $? -eq 0 ]; then
  echo "Backup of volume '$VOLUME_NAME' completed successfully!"
else
  echo "Backup of volume '$VOLUME_NAME' failed!"
  exit 1
fi