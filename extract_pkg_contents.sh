#!/bin/bash

# Check if a .pkg file path was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-pkg>"
    exit 1
fi

PKG_PATH="$1"
EXPAND_DIR="extracted_pkg"
PAYLOAD_DIR="payload_contents"

# Ensure the provided file exists
if [ ! -f "$PKG_PATH" ]; then
    echo "File not found: $PKG_PATH"
    exit 1
fi

# Expand the .pkg file
echo "Expanding $PKG_PATH..."
pkgutil --expand "$PKG_PATH" "$EXPAND_DIR"

# Create a directory for Payload contents
mkdir -p "$PAYLOAD_DIR"

# Find and extract Payload files
echo "Extracting Payload files..."
find "$EXPAND_DIR" -name Payload | while read -r payload; do
    # Use tar to extract the Payload, sometimes it's gzipped, hence z option might be needed
    # Adjust the tar command according to the actual content (zipped or not)
    (cd "$PAYLOAD_DIR" && tar -xf "$payload")
done

# List the extracted contents
echo "Contents of the .pkg file:"
ls -lR "$PAYLOAD_DIR"

# Cleanup (optional)
read -p "Do you want to remove the extracted files? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Removing extracted files..."
    rm -rf "$EXPAND_DIR" "$PAYLOAD_DIR"
else
    echo "Extracted files kept in $EXPAND_DIR and $PAYLOAD_DIR"
fi

# Make the script executable with the command chmod +x extract_pkg_contents.sh
# Usage: ./extract_pkg_contents.sh /path/to/your/package.pkg

