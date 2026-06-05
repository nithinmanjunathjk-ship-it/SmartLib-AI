import 'package:flutter/material.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

  final List<Map<String, String>> history = const [
    {'title': 'The Pragmatic Programmer', 'author': 'David Thomas', 'borrowed': 'May 1, 2026', 'returned': 'May 20, 2026', 'duration': '19 days'},
    {'title': 'Clean Architecture', 'author': 'Robert C. Martin', 'borrowed': 'Mar 25, 2026', 'returned': 'Apr 15, 2026', 'duration': '21 days'},
    {'title': 'Refactoring', 'author': 'Martin Fowler', 'borrowed': 'Feb 15, 2026', 'returned': 'Mar 8, 2026', 'duration': '21 days'},
    {'title': 'Design Patterns', 'author': 'Gang of Four', 'borrowed': 'Jan 5, 2026', 'returned': 'Jan 28, 2026', 'duration': '23 days'},
    {'title': 'The Mythical Man-Month', 'author': 'Frederick P. Brooks', 'borrowed': 'Dec 1, 2025', 'returned': 'Dec 22, 2025', 'duration': '21 days'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('Reading History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (_, i) {
          final item = history[i];
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
                      Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(item['author']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${item['borrowed']} – ${item['returned']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(8)),
                  child: Text(item['duration']!, style: const TextStyle(color: Color(0xFF5B67CA), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
