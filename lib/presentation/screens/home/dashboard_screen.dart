import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/book_card_widget.dart';
import '../../widgets/shimmer_loading.dart';
import '../books/books_screen.dart';
import '../scanner/qr_scanner_screen.dart';
import 'home_screen.dart';

// Real book data with Open Library covers
final _recommendedBooks = [
  {
    'title': 'The Great Gatsby',
    'author': 'F. Scott Fitzgerald',
    'coverUrl': 'https://covers.openlibrary.org/b/id/8432880-M.jpg',
  },
  {
    'title': 'To Kill a Mockingbird',
    'author': 'Harper Lee',
    'coverUrl': 'https://covers.openlibrary.org/b/id/8810494-M.jpg',
  },
  {
    'title': 'Clean Code',
    'author': 'Robert C. Martin',
    'coverUrl': 'https://covers.openlibrary.org/b/id/8621270-M.jpg',
  },
  {
    'title': 'Introduction to Algorithms',
    'author': 'Cormen et al.',
    'coverUrl': 'https://covers.openlibrary.org/b/id/8344797-M.jpg',
  },
  {
    'title': 'The Pragmatic Programmer',
    'author': 'Hunt & Thomas',
    'coverUrl': 'https://covers.openlibrary.org/b/id/8276874-M.jpg',
  },
];

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', userId)
            .single();
        setState(() {
          _currentUser = UserModel.fromJson(response);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );
  }

  void _navigateToBooks() {
    ref.read(currentIndexProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const ShimmerLoading()
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadUserData,
                child: CustomScrollView(
                  slivers: [
                    _buildHeader(),
                    _buildQuickActions(),
                    _buildDueBooksSection(),
                    _buildRecommendedBooksSection(),
                    _buildAnnouncementsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    _currentUser?.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser?.fullName ?? 'User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No new notifications')),
                    );
                  },
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Books Borrowed', '3'),
                  Container(width: 1, height: 30, color: Colors.white),
                  _buildStat('Reading Time', '24h'),
                  Container(width: 1, height: 30, color: Colors.white),
                  _buildStat('Pending Fines', '₹0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
      ],
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard('Scan QR', Icons.qr_code_scanner_rounded,
                      AppColors.primary, _openQRScanner),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard('Search Books', Icons.search_rounded,
                      AppColors.accent, _navigateToBooks),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard('Book Seat', Icons.event_seat_rounded,
                      AppColors.success, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seat booking coming soon!')),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard('Wishlist', Icons.favorite_outline_rounded,
                      AppColors.warning, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wishlist coming soon!')),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDueBooksSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Soon',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => ref.read(currentIndexProvider.notifier).state = 2,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('No books due soon',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedBooksSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recommended for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendedBooks.length,
                itemBuilder: (context, index) {
                  final book = _recommendedBooks[index];
                  return Padding(
                    padding: EdgeInsets.only(right: index < _recommendedBooks.length - 1 ? 16 : 0),
                    child: BookCardWidget(
                      title: book['title']!,
                      author: book['author']!,
                      coverUrl: book['coverUrl'],
                      onTap: () => _navigateToBooks(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Announcements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Library will be closed on Sunday for maintenance',
                      style: TextStyle(color: AppColors.info.withOpacity(0.9)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
