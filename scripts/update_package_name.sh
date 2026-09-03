#!/bin/bash
# scripts/update_package_name.sh
# Usage: ./scripts/update_package_name.sh com.example.newapp

set -e

if [ -z "$1" ]; then
  echo "❌ Error: New package name required."
  echo "Usage: ./scripts/update_package_name.sh com.example.newapp"
  exit 1
fi

NEW_PACKAGE_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔄 Changing App Package Name / Bundle ID to: \"$NEW_PACKAGE_NAME\"..."
cd "$ROOT_DIR"
flutter pub run change_app_package_name:main "$NEW_PACKAGE_NAME"

echo "🎉 Package name / Bundle ID successfully changed to \"$NEW_PACKAGE_NAME\"!"
