#!/bin/bash

# SmartLib AI - Quick Start Script
# This script helps you set up and run the project quickly

echo "🚀 SmartLib AI - Quick Start"
echo "=============================="
echo ""

# Check Flutter installation
echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Check for project directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Run this script from the project root directory"
    exit 1
fi

echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "🔍 Running Flutter doctor..."
flutter doctor

echo ""
echo "📱 Available commands:"
echo ""
echo "  1. Run app (debug mode):"
echo "     flutter run"
echo ""
echo "  2. Build APK (release):"
echo "     flutter build apk --release"
echo ""
echo "  3. Build APK (debug):"
echo "     flutter build apk --debug"
echo ""
echo "  4. Run tests:"
echo "     flutter test"
echo ""
echo "  5. Analyze code:"
echo "     flutter analyze"
echo ""

read -p "Do you want to run the app now? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Running app..."
    flutter run
fi

echo ""
echo "✨ Setup complete! Happy coding!"
