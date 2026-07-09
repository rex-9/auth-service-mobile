#!/bin/bash
# scripts/update_app_icon.sh
# Usage: ./scripts/update_app_icon.sh

echo "🔄 Updating app icons..."
flutter pub run flutter_launcher_icons:main
echo "✅ App icon updated successfully!"