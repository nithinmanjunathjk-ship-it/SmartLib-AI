# SmartLib AI - Complete Setup Guide

## 📋 Prerequisites

Before starting, ensure you have:
- Flutter SDK 3.16.0+
- Android Studio or VS Code
- Git
- Supabase account (free tier works)

## 🚀 Step-by-Step Setup

### 1. Supabase Setup

1. **Create Supabase Project**
   - Go to https://supabase.com
   - Click "New Project"
   - Fill in project details
   - Wait for project to be ready

2. **Get Credentials**
   - Go to Project Settings → API
   - Copy `Project URL`
   - Copy `anon public` key

3. **Run SQL Schema**
   - Go to SQL Editor
   - Copy content from `supabase_schema.sql`
   - Click "Run"

4. **Create Storage Buckets**
   - Go to Storage
   - Create bucket: `book-covers` (public)
   - Create bucket: `profile-images` (public)
   - Create bucket: `digital-books` (private)

### 2. Project Setup

```bash
# Clone repository
git clone <your-repo-url>
cd smartlib_ai

# Install dependencies
flutter pub get

# Configure Supabase
# Edit lib/core/constants/supabase_constants.dart
# Replace YOUR_SUPABASE_URL and YOUR_SUPABASE_ANON_KEY
```

### 3. Run the App

```bash
# Check for issues
flutter doctor

# Run on connected device
flutter run

# Or build APK
flutter build apk --release
```

## 🔧 Configuration

Update `lib/core/constants/supabase_constants.dart`:
```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

## 📱 Testing the App

1. Run the app
2. Create a new account (Sign Up)
3. Check email for verification link
4. Login with credentials
5. Explore features

## 🔨 Building APK

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## 🐛 Troubleshooting

### Common Issues

**Issue: Flutter not found**
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

**Issue: Gradle build fails**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Issue: Supabase connection fails**
- Check internet connection
- Verify Supabase credentials
- Check Supabase project status

## 📚 Next Steps

1. Customize app branding
2. Add sample books data
3. Test all features
4. Deploy to Play Store

## 💡 Tips

- Use real device for testing QR scanner
- Enable USB debugging on Android
- Keep Supabase credentials secure
- Regular backups of database

## 🆘 Support

For help:
- Check README.md
- Review Supabase docs
- Open GitHub issue
