#!/bin/bash

# Target directory (default to current directory if not provided)
TARGET_DIR="${1:-.}"

# Find files recursively
# 1. -type f: only files
# 2. -name "*.*.*": looking for files with at least two dots
find "$TARGET_DIR" -type f -name "*.*.*" | while read -r FILE; do
    # Extract directory and filename
    DIR=$(dirname "$FILE")
    BASENAME=$(basename "$FILE")

    # Use regex to remove the hash
    # This looks for a dot followed by alphanumeric characters right before the extension
    NEW_NAME=$(echo "$BASENAME" | sed -E 's/\.[a-f0-9]{8,12}\.([^.]+)$/.\1/')

    # Only rename if the name actually changed
    if [ "$BASENAME" != "$NEW_NAME" ]; then
        echo "Renaming: $BASENAME -> $NEW_NAME"
        mv "$FILE" "$DIR/$NEW_NAME"
    fi
done