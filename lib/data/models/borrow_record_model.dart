class BorrowRecordModel {
  final String id;
  final String userId;
  final String bookId;
  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCover;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final String status; // 'active', 'returned', 'overdue'
  final double? fineAmount;
  final bool finePaid;
  
  BorrowRecordModel({
    required this.id,
    required this.userId,
    required this.bookId,
    this.bookTitle,
    this.bookAuthor,
    this.bookCover,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    this.fineAmount,
    this.finePaid = false,
  });
  
  factory BorrowRecordModel.fromJson(Map<String, dynamic> json) {
    return BorrowRecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      bookAuthor: json['book_author'] as String?,
      bookCover: json['book_cover'] as String?,
      borrowDate: DateTime.parse(json['borrow_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      returnDate: json['return_date'] != null 
          ? DateTime.parse(json['return_date'] as String) 
          : null,
      status: json['status'] as String,
      fineAmount: json['fine_amount'] != null 
          ? (json['fine_amount'] as num).toDouble() 
          : null,
      finePaid: json['fine_paid'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'borrow_date': borrowDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'status': status,
      'fine_amount': fineAmount,
      'fine_paid': finePaid,
    };
  }
  
  int get daysUntilDue {
    if (returnDate != null) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }
  
  bool get isOverdue {
    if (returnDate != null) return false;
    return DateTime.now().isAfter(dueDate);
  }
  
  int get overdueDays {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }
}
