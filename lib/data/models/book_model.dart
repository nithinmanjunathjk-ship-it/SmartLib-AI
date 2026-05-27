class BookModel {
  final String id;
  final String title;
  final String author;
  final String? isbn;
  final String? description;
  final String? coverImage;
  final String categoryId;
  final String? categoryName;
  final int totalCopies;
  final int availableCopies;
  final String? rackLocation;
  final String? publisher;
  final int? publishYear;
  final List<String> tags;
  final String? digitalBookUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.isbn,
    this.description,
    this.coverImage,
    required this.categoryId,
    this.categoryName,
    required this.totalCopies,
    required this.availableCopies,
    this.rackLocation,
    this.publisher,
    this.publishYear,
    this.tags = const [],
    this.digitalBookUrl,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String?,
      totalCopies: json['total_copies'] as int? ?? 1,
      availableCopies: json['available_copies'] as int? ?? 1,
      rackLocation: json['rack_location'] as String?,
      publisher: json['publisher'] as String?,
      publishYear: json['publish_year'] as int?,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      digitalBookUrl: json['digital_book_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'description': description,
      'cover_image': coverImage,
      'category_id': categoryId,
      'total_copies': totalCopies,
      'available_copies': availableCopies,
      'rack_location': rackLocation,
      'publisher': publisher,
      'publish_year': publishYear,
      'tags': tags,
      'digital_book_url': digitalBookUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  bool get isAvailable => availableCopies > 0;
  
  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? description,
    String? coverImage,
    String? categoryId,
    String? categoryName,
    int? totalCopies,
    int? availableCopies,
    String? rackLocation,
    String? publisher,
    int? publishYear,
    List<String>? tags,
    String? digitalBookUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
      rackLocation: rackLocation ?? this.rackLocation,
      publisher: publisher ?? this.publisher,
      publishYear: publishYear ?? this.publishYear,
      tags: tags ?? this.tags,
      digitalBookUrl: digitalBookUrl ?? this.digitalBookUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
