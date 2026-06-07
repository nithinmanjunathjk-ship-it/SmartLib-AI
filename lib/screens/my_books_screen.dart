import 'package:flutter/material.dart';
import '../models.dart';

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Book> _borrowedBooks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _borrowedBooks = List.from(sampleBorrowedBooks);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _extendBook(Book book) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Extend Due Date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book: ${book.title}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Extend the due date by 7 days?'),
            if (book.dueDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'New due date: ${book.dueDate!.add(const Duration(days: 7)).day}/${book.dueDate!.add(const Duration(days: 7)).month}/${book.dueDate!.add(const Duration(days: 7)).year}',
                style: const TextStyle(color: Color(0xFF5B67CA)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final idx = _borrowedBooks.indexWhere((b) => b.id == book.id);
                if (idx != -1) {
                  _borrowedBooks[idx] = Book(
                    id: book.id,
                    title: book.title,
                    author: book.author,
                    isbn: book.isbn,
                    category: book.category,
                    isAvailable: false,
                    dueDate: book.dueDate?.add(const Duration(days: 7)),
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Due date extended by 7 days!'),
                  backgroundColor: Color(0xFF5B67CA),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B67CA), foregroundColor: Colors.white),
            child: const Text('Extend'),
          ),
        ],
      ),
    );
  }

  void _returnBook(Book book) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Return Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Return "${book.title}"?', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Please make sure you have the physical book ready to return to the library.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _borrowedBooks.removeWhere((b) => b.id == book.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${book.title}" returned successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('My Books', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF5B67CA),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF5B67CA),
          tabs: const [Tab(text: 'Borrowed'), Tab(text: 'History'), Tab(text: 'Reserved')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Borrowed tab
          _borrowedBooks.isEmpty
              ? const Center(child: Text('No borrowed books', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _borrowedBooks.length,
                  itemBuilder: (_, i) {
                    final book = _borrowedBooks[i];
                    final days = book.dueDate?.difference(DateTime.now()).inDays ?? 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56, height: 72,
                                decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.menu_book, color: Color(0xFF5B67CA), size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const SizedBox(height: 4),
                                    Text(book.author, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: days <= 1 ? Colors.red.shade50 : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        days < 0 ? 'Overdue by ${days.abs()} days' : days == 0 ? 'Due today' : 'Due in $days days',
                                        style: TextStyle(
                                          color: days <= 1 ? Colors.red : Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _extendBook(book),
                                  icon: const Icon(Icons.calendar_month, size: 18),
                                  label: const Text('Extend'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF5B67CA),
                                    side: const BorderSide(color: Color(0xFF5B67CA)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _returnBook(book),
                                  icon: const Icon(Icons.check_circle_outline, size: 18),
                                  label: const Text('Return'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5B67CA),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

          // History tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HistoryCard(title: 'The Pragmatic Programmer', author: 'David Thomas', returnedDate: 'May 20, 2026'),
              _HistoryCard(title: 'Clean Architecture', author: 'Robert C. Martin', returnedDate: 'Apr 15, 2026'),
              _HistoryCard(title: 'Refactoring', author: 'Martin Fowler', returnedDate: 'Mar 8, 2026'),
            ],
          ),

          // Reserved tab
          const Center(child: Text('No reserved books', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String author;
  final String returnedDate;
  const _HistoryCard({required this.title, required this.author, required this.returnedDate});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(author, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    Text('Returned $returnedDate', style: const TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
