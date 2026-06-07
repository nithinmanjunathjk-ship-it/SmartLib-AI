# SmartLib - Smart Library Management App

## Setup Instructions

### Prerequisites
- Flutter SDK >= 3.0.0
- Android Studio or VS Code with Flutter extension
- Android device/emulator (API 21+) or iOS device/simulator

### Installation

1. Extract the zip file
2. Open terminal in the project folder
3. Run:

```bash
flutter pub get
flutter run
```

### Features Fixed
- **My Books Screen**: Extend and Return buttons now fully functional
  - Extend: Opens dialog to extend due date by 7 days
  - Return: Opens confirmation dialog, removes book from borrowed list

- **Profile Screen**: All menu items now navigate correctly
  - Edit Profile, My Fines, Reading History, Wishlist, Notifications all open their screens

- **QR Scanner**: Full camera scanning capability
  - Scans any QR code, barcode, or ISBN
  - Torch/flashlight toggle
  - Camera flip (front/back)
  - Manual code entry fallback
  - Shows scanned result with relevant action buttons

- **Student Details**: Displayed in Profile with correct USN and email

### Permissions Required
- **Camera**: For QR code scanning
- **Internet**: For future API integration

### Package Dependencies
- `mobile_scanner: ^5.1.0` – QR/barcode scanning
- `shared_preferences: ^2.2.2` – Local storage
- `intl: ^0.19.0` – Date formatting
- `url_launcher: ^6.2.4` – Open URLs from QR codes
