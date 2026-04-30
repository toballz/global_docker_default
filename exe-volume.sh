#!/bin/bash

# Check if at least 2 arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <backup|restore> <volume> [directory]"
  exit 1
fi

COMMAND=$1
VOLUME_NAME=$2
BACKUP_DIR=${3:-.}  # Default to current directory if not provided

case "$COMMAND" in
  backup)
    # Verify that the backup directory exists
    if [ ! -d "$BACKUP_DIR" ]; then
      echo "Backup directory does not exist: $BACKUP_DIR"
      exit 1
    fi

    BACKUP_FILE="${VOLUME_NAME}_$(date +%F).tar.gz"

    docker run --rm \
      -v "$VOLUME_NAME":/volume \
      -v "$BACKUP_DIR":/backup \
      alpine tar czf "/backup/$BACKUP_FILE" -C /volume .

    if [ $? -eq 0 ]; then
      echo "Backup of volume '$VOLUME_NAME' saved to '$BACKUP_DIR/$BACKUP_FILE'"
    else
      echo "Backup of volume '$VOLUME_NAME' failed!"
      exit 1
    fi
    ;;

  restore)
    # Find the backup file — either a specific file or the latest match in the directory
    if [ -f "$BACKUP_DIR" ]; then
      # A direct file path was passed as the third argument
      BACKUP_FILE=$(basename "$BACKUP_DIR")
      BACKUP_DIR=$(dirname "$BACKUP_DIR")
    else
      # Look for the latest matching tar.gz in the directory
      if [ ! -d "$BACKUP_DIR" ]; then
        echo "Directory does not exist: $BACKUP_DIR"
        exit 1
      fi
      BACKUP_FILE=$(ls -t "$BACKUP_DIR/${VOLUME_NAME}_"*.tar.gz 2>/dev/null | head -1 | xargs basename 2>/dev/null)
      if [ -z "$BACKUP_FILE" ]; then
        echo "No backup file found for volume '$VOLUME_NAME' in '$BACKUP_DIR'"
        exit 1
      fi
    fi

    echo "Restoring '$BACKUP_FILE' into volume '$VOLUME_NAME'..."

    docker run --rm \
      -v "$VOLUME_NAME":/volume \
      -v "$BACKUP_DIR":/backup \
      alpine tar xzf "/backup/$BACKUP_FILE" -C /volume

    if [ $? -eq 0 ]; then
      echo "Volume '$VOLUME_NAME' restored successfully from '$BACKUP_FILE'"
    else
      echo "Restore of volume '$VOLUME_NAME' failed!"
      exit 1
    fi
    ;;

  *)
    echo "Unknown command: $COMMAND"
    echo "Usage: $0 <backup|restore> <volume> [directory]"
    exit 1
    ;;
esac