class AppConstants {
  // App Info
  static const String appName = 'SmartLib AI';
  static const String appVersion = '1.0.0';
  
  // Fine System
  static const double dailyFineAmount = 5.0;
  static const int maxBorrowDays = 14;
  static const int maxBooksPerUser = 3;
  
  // Seat Booking
  static const int maxSeatBookingHours = 4;
  
  // Reservation
  static const int reservationExpiryDays = 2;
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDuration = Duration(seconds: 2);
}
