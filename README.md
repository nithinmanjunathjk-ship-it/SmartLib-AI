# 📚 SmartLib AI - Library Management System

A production-ready, modern, full-stack mobile application for smart library management built with Flutter and Supabase.

![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue)
![Supabase](https://img.shields.io/badge/Supabase-Latest-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## 🌟 Features

### Authentication & User Management
- ✅ Email/Password authentication
- ✅ Email verification
- ✅ Role-based access (Student, Librarian, Admin)
- ✅ Profile management with image upload
- ✅ Student ID (USN) verification

### Book Management
- 📖 Browse thousands of books
- 🔍 Smart search (title, author, ISBN, tags)
- 🎯 Category-based filtering
- 📊 Book availability tracking
- 🏷️ Multiple copies management
- 📍 Rack/Shelf location tracking
- 📱 QR/Barcode scanning support

### Borrow & Return System
- 📲 QR code scanning for instant issue/return
- ⏰ Automatic due date calculation
- 🔔 Due date reminders
- 📋 Borrow history tracking
- 🚫 Borrow limits enforcement

### Reservation System
- 📌 Reserve unavailable books
- ⏳ Waiting queue management
- 🔔 Auto-notify when available
- ⌛ Reservation expiry timer

### Fine Management
- 💰 Automatic fine calculation
- 📈 Daily fine increment
- 💳 Fine payment tracking
- 📊 Fine history dashboard

### Seat Booking
- 🪑 Live seat availability
- ⏱️ Time slot booking
- 📊 Occupancy analytics

### Smart Features
- 🤖 AI-based book recommendations
- 📊 Reading analytics & statistics
- ❤️ Wishlist management
- 🔔 Push notifications
- 🌙 Dark/Light mode
- 📴 Offline support

### Admin Dashboard
- 📈 Analytics & insights
- 👥 User management
- 📚 Book inventory management
- 💰 Fine collection reports
- 📢 Announcements

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.16.0 or higher)
- Android Studio / VS Code
- Dart SDK (3.0.0 or higher)
- Supabase account

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/smartlib_ai.git
cd smartlib_ai
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Supabase**

- Create a new project at [supabase.com](https://supabase.com)
- Copy your project URL and anon key
- Run the SQL schema from `supabase_schema.sql` in your Supabase SQL editor
- Create storage buckets:
  - `book-covers` (public)
  - `profile-images` (public)
  - `digital-books` (private)

4. **Configure environment**

Update `lib/core/constants/supabase_constants.dart`:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

5. **Run the app**
```bash
flutter run
```

## 📱 Building APK

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## 🔄 GitHub Actions

The project includes automated CI/CD pipeline that:
- Builds APK on every push
- Runs tests and analysis
- Uploads APK as artifact
- Creates GitHub releases

## 📂 Project Structure

```
smartlib_ai/
├── lib/
│   ├── core/
│   │   ├── constants/       # App constants and Supabase config
│   │   ├── theme/          # App theme and colors
│   │   ├── utils/          # Utility functions
│   │   └── widgets/        # Core reusable widgets
│   ├── data/
│   │   ├── datasources/    # Supabase data sources
│   │   ├── models/         # Data models
│   │   └── repositories/   # Repository implementations
│   ├── domain/
│   │   ├── entities/       # Business entities
│   │   ├── repositories/   # Repository interfaces
│   │   └── usecases/       # Business logic
│   └── presentation/
│       ├── screens/        # All app screens
│       ├── providers/      # Riverpod providers
│       └── widgets/        # UI widgets
├── assets/
│   ├── images/            # Image assets
│   ├── icons/             # Icon assets
│   └── fonts/             # Custom fonts
├── android/               # Android native code
├── ios/                   # iOS native code
├── .github/
│   └── workflows/         # GitHub Actions workflows
├── pubspec.yaml          # Dependencies
└── README.md             # This file
```

## 🎨 Design System

### Colors
- Primary: `#6366F1` (Indigo)
- Accent: `#EC4899` (Pink)
- Success: `#10B981` (Green)
- Warning: `#F59E0B` (Amber)
- Error: `#EF4444` (Red)

### Typography
- Font Family: Poppins
- Heading: 20-32px, Bold
- Body: 14-16px, Regular
- Caption: 12-14px, Regular

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- Secure API communication
- Input validation
- Error handling
- Authentication required for all operations

## 📊 Database Schema

The complete database schema includes:
- Users & Authentication
- Books & Categories
- Borrow Records
- Reservations
- Fines
- Seat Bookings
- Notifications
- Reading History
- Analytics Logs
- Wishlist
- Announcements

See `supabase_schema.sql` for complete schema.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Dependencies

### Core
- flutter_riverpod: State management
- supabase_flutter: Backend & authentication
- google_fonts: Typography

### UI
- shimmer: Loading animations
- lottie: Complex animations
- flutter_animate: Simple animations
- glassmorphism: Modern UI effects

### Features
- qr_code_scanner: QR scanning
- flutter_pdfview: PDF viewer
- fl_chart: Analytics charts
- image_picker: Image selection
- shared_preferences: Local storage

See `pubspec.yaml` for complete list.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- All contributors and supporters

## 📧 Support

For support, email support@smartlib.ai or open an issue in the GitHub repository.

## 🗺️ Roadmap

- [ ] Biometric authentication
- [ ] Multi-language support
- [ ] Voice assistant integration
- [ ] AI chatbot for library help
- [ ] OCR for scanning book details
- [ ] Export reports as PDF
- [ ] Social features (reading groups)
- [ ] Gamification & achievements

---

Made with ❤️ for Engineering Design Tinkering Lab
