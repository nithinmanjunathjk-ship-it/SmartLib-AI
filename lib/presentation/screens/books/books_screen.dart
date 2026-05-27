import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/book_card_widget.dart';
import '../scanner/qr_scanner_screen.dart';

// Real books with Open Library cover images
final _allBooks = [
  {'title': 'The Great Gatsby', 'author': 'F. Scott Fitzgerald', 'category': 'Fiction', 'coverUrl': 'https://covers.openlibrary.org/b/id/8432880-M.jpg'},
  {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee', 'category': 'Fiction', 'coverUrl': 'https://covers.openlibrary.org/b/id/8810494-M.jpg'},
  {'title': 'Clean Code', 'author': 'Robert C. Martin', 'category': 'Technology', 'coverUrl': 'https://covers.openlibrary.org/b/id/8621270-M.jpg'},
  {'title': 'Introduction to Algorithms', 'author': 'Thomas H. Cormen', 'category': 'Technology', 'coverUrl': 'https://covers.openlibrary.org/b/id/8344797-M.jpg'},
  {'title': 'The Pragmatic Programmer', 'author': 'David Thomas', 'category': 'Technology', 'coverUrl': 'https://covers.openlibrary.org/b/id/8276874-M.jpg'},
  {'title': 'Sapiens', 'author': 'Yuval Noah Harari', 'category': 'Non-Fiction', 'coverUrl': 'https://covers.openlibrary.org/b/id/8739161-M.jpg'},
  {'title': 'A Brief History of Time', 'author': 'Stephen Hawking', 'category': 'Science', 'coverUrl': 'https://covers.openlibrary.org/b/id/8739395-M.jpg'},
  {'title': 'The Origin of Species', 'author': 'Charles Darwin', 'category': 'Science', 'coverUrl': 'https://covers.openlibrary.org/b/id/8408567-M.jpg'},
  {'title': 'Calculus Made Easy', 'author': 'Silvanus Thompson', 'category': 'Mathematics', 'coverUrl': 'https://covers.openlibrary.org/b/id/8091016-M.jpg'},
  {'title': 'Linear Algebra Done Right', 'author': 'Sheldon Axler', 'category': 'Mathematics', 'coverUrl': 'https://covers.openlibrary.org/b/id/7898838-M.jpg'},
  {'title': 'Design Patterns', 'author': 'Gang of Four', 'category': 'Technology', 'coverUrl': 'https://covers.openlibrary.org/b/id/8741469-M.jpg'},
  {'title': 'Thinking Fast and Slow', 'author': 'Daniel Kahneman', 'category': 'Non-Fiction', 'coverUrl': 'https://covers.openlibrary.org/b/id/8739144-M.jpg'},
  {'title': '1984', 'author': 'George Orwell', 'category': 'Fiction', 'coverUrl': 'https://covers.openlibrary.org/b/id/8575708-M.jpg'},
  {'title': 'The Selfish Gene', 'author': 'Richard Dawkins', 'category': 'Science', 'coverUrl': 'https://covers.openlibrary.org/b/id/8739206-M.jpg'},
  {'title': 'The Art of War', 'author': 'Sun Tzu', 'category': 'History', 'coverUrl': 'https://covers.openlibrary.org/b/id/8091233-M.jpg'},
  {'title': 'Guns Germs and Steel', 'author': 'Jared Diamond', 'category': 'History', 'coverUrl': 'https://covers.openlibrary.org/b/id/8739348-M.jpg'},
];

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All', 'Fiction', 'Non-Fiction', 'Science', 'Technology', 'History', 'Mathematics',
  ];

  List<Map<String, String>> get _filteredBooks {
    return _allBooks.where((book) {
      final matchesCategory =
          _selectedCategory == 'All' || book['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          book['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['author']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Library'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter options coming soon!')),
              );
            },
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildBooksList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QRScannerScreen()),
          );
        },
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Scan Book'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search books, authors, ISBN...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.clear),
                )
              : IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice search coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.mic_rounded),
                ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBooksList() {
    final books = _filteredBooks;
    if (books.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppColors.onSurfaceVariant),
            SizedBox(height: 16),
            Text('No books found', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCardWidget(
          title: book['title']!,
          author: book['author']!,
          coverUrl: book['coverUrl'],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening: ${book['title']}')),
            );
          },
        );
      },
    );
  }
}
