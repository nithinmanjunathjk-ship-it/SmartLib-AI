import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, String>> wishlist = [
    {'title': 'The Art of Computer Programming', 'author': 'Donald Knuth', 'category': 'Computer Science'},
    {'title': 'Structure and Interpretation of Programs', 'author': 'Harold Abelson', 'category': 'Computer Science'},
    {'title': 'Grokking Algorithms', 'author': 'Aditya Bhargava', 'category': 'Algorithms'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: wishlist.isEmpty
          ? const Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Your wishlist is empty', style: TextStyle(color: Colors.grey)),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.length,
              itemBuilder: (_, i) {
                final item = wishlist[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 60,
                        decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.menu_book, color: Color(0xFF5B67CA)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(item['author']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(6)),
                              child: Text(item['category']!, style: const TextStyle(color: Color(0xFF5B67CA), fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          setState(() => wishlist.removeAt(i));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from wishlist')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
