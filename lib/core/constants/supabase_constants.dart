class SupabaseConstants {
  static const String supabaseUrl = 'https://qpccfwkzcyrrexotddfh.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_drngaSx14a9JTHUaAZOs1w_PV3cqMTM';
  
  // Storage buckets
  static const String bookCoversBucket = 'book-covers';
  static const String profileImagesBucket = 'profile-images';
  static const String digitalBooksBucket = 'digital-books';
  
  // Table names
  static const String usersTable = 'users';
  static const String booksTable = 'books';
  static const String categoriesTable = 'categories';
  static const String bookCopiesTable = 'book_copies';
  static const String borrowRecordsTable = 'borrow_records';
  static const String reservationsTable = 'reservations';
  static const String finesTable = 'fines';
  static const String notificationsTable = 'notifications';
  static const String readingHistoryTable = 'reading_history';
  static const String seatsTable = 'seats';
  static const String seatBookingsTable = 'seat_bookings';
  static const String adminsTable = 'admins';
  static const String analyticsLogsTable = 'analytics_logs';
  static const String wishlistTable = 'wishlist';
  static const String announcementsTable = 'announcements';
}
