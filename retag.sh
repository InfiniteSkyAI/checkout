#!/bin/bash
set -e

NEW_TAG=$1 # e.g., v1.8.0

if [[ ! $NEW_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Tag must be in format vX.Y.Z (e.g., v1.8.0)"
    exit 1
fi

# Extract Major and Minor versions
# v1.8.0 -> v1 (Major) and v1.8 (Minor)
MAJOR_TAG=$(echo $NEW_TAG | cut -d. -f1)
MINOR_TAG=$(echo $NEW_TAG | cut -d. -f1,2)

echo "Updating tags for $NEW_TAG..."

# Create/Move the tags locally
git tag -a "$NEW_TAG" -m "Release $NEW_TAG" -f
git tag -a "$MINOR_TAG" -m "Moving $MINOR_TAG to $NEW_TAG" -f
git tag -a "$MAJOR_TAG" -m "Moving $MAJOR_TAG to $NEW_TAG" -f

# Push to the mirror
# Note: We use --force for the moving tags
echo "Pushing tags to mirror..."
git push origin "$NEW_TAG"
git push origin "$MINOR_TAG" --force
git push origin "$MAJOR_TAG" --force

echo "Successfully updated $NEW_TAG, $MINOR_TAG, and $MAJOR_TAG"
