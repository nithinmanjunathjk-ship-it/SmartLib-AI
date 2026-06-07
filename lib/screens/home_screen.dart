import 'package:flutter/material.dart';
import '../models.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${sampleStudent.name} 👋',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text('Welcome to SmartLib', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF5B67CA),
                    radius: 22,
                    child: Text(sampleStudent.name[0],
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search books, authors...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF5B67CA)),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // QR Scan Banner
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B67CA), Color(0xFF8B95E0)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Scan QR Code', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Scan any QR code to borrow or return books instantly', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 36),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  Expanded(child: _StatCard(icon: Icons.menu_book, color: const Color(0xFFE8EAFF), iconColor: const Color(0xFF5B67CA), value: '${sampleStudent.booksBorrowed}', label: 'Books Borrowed')),
                  const SizedBox(width: 16),
                  Expanded(child: _StatCard(icon: Icons.access_time, color: const Color(0xFFFFE8F0), iconColor: const Color(0xFFE91E8C), value: '${sampleStudent.readingHours}h', label: 'Reading Time')),
                ],
              ),
              const SizedBox(height: 24),

              // Due soon
              const Text('Due Soon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...sampleBorrowedBooks
                  .where((b) => b.dueDate != null && b.dueDate!.difference(DateTime.now()).inDays <= 3)
                  .map((book) => _DueSoonCard(book: book)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.color, required this.iconColor, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _DueSoonCard extends StatelessWidget {
  final Book book;
  const _DueSoonCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final days = book.dueDate!.difference(DateTime.now()).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: days <= 1 ? Colors.red.shade200 : Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 56,
            decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.menu_book, color: Color(0xFF5B67CA)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(book.author, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: days <= 1 ? Colors.red.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              days == 0 ? 'Due today' : 'Due in $days days',
              style: TextStyle(color: days <= 1 ? Colors.red : Colors.orange, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
