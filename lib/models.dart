class Student {
  final String id;
  final String name;
  final String email;
  final String usn;
  final String department;
  final String phone;
  final int booksBorrowed;
  final int readingHours;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.usn,
    required this.department,
    required this.phone,
    required this.booksBorrowed,
    required this.readingHours,
  });
}

class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final bool isAvailable;
  final DateTime? dueDate;
  final String? coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    this.isAvailable = true,
    this.dueDate,
    this.coverUrl,
  });
}

// Sample data
final sampleStudent = Student(
  id: '1',
  name: 'Vikas',
  email: 'vvce25cse0465@vvce.ac.in',
  usn: 'USN123456',
  department: 'Computer Science & Engineering',
  phone: '+91 9876543210',
  booksBorrowed: 24,
  readingHours: 48,
);

final sampleBorrowedBooks = [
  Book(
    id: '1',
    title: 'Introduction to Algorithms',
    author: 'Thomas H. Cormen',
    isbn: '978-0262033848',
    category: 'Computer Science',
    isAvailable: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
  ),
  Book(
    id: '2',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    isbn: '978-0132350884',
    category: 'Software Engineering',
    isAvailable: false,
    dueDate: DateTime.now().add(const Duration(days: 7)),
  ),
  Book(
    id: '3',
    title: 'Design Patterns',
    author: 'Gang of Four',
    isbn: '978-0201633610',
    category: 'Software Engineering',
    isAvailable: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  ),
];

final sampleBooks = [
  const Book(id: '4', title: 'The Pragmatic Programmer', author: 'David Thomas', isbn: '978-0135957059', category: 'Software Engineering'),
  const Book(id: '5', title: 'Structure and Interpretation of Computer Programs', author: 'Harold Abelson', isbn: '978-0262510875', category: 'Computer Science'),
  const Book(id: '6', title: 'Artificial Intelligence: A Modern Approach', author: 'Stuart Russell', isbn: '978-0134610993', category: 'AI/ML'),
  const Book(id: '7', title: 'Database System Concepts', author: 'Abraham Silberschatz', isbn: '978-0078022159', category: 'Database'),
  const Book(id: '8', title: 'Computer Networks', author: 'Andrew Tanenbaum', isbn: '978-0132126953', category: 'Networking'),
  const Book(id: '9', title: 'Operating System Concepts', author: 'Abraham Silberschatz', isbn: '978-1119800361', category: 'OS'),
];
