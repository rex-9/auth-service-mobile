#!/bin/bash
# scripts/update_app_version.sh
# Usage: ./scripts/update_app_version.sh 1.0.1

if [ -z "$1" ]; then
  echo "Usage: ./scripts/update_app_version.sh 1.0.1"
  exit 1
fi

NEW_VERSION="$1"

# Read current build number
CURRENT_BUILD=$(grep 'version:' pubspec.yaml | sed -E 's/.*\+([0-9]+).*/\1/')
NEW_BUILD=$((CURRENT_BUILD + 1))

# Update pubspec.yaml
sed -i '' "s/version: .*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml

echo "✅ Version updated to: $NEW_VERSION+$NEW_BUILD"