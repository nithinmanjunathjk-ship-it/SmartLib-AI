class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? usn;
  final String? department;
  final int? semester;
  final String? profileImage;
  final String role; // 'student', 'librarian', 'admin'
  final DateTime createdAt;
  final bool isEmailVerified;
  
  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.usn,
    this.department,
    this.semester,
    this.profileImage,
    this.role = 'student',
    required this.createdAt,
    this.isEmailVerified = false,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      usn: json['usn'] as String?,
      department: json['department'] as String?,
      semester: json['semester'] as int?,
      profileImage: json['profile_image'] as String?,
      role: json['role'] as String? ?? 'student',
      createdAt: DateTime.parse(json['created_at'] as String),
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'usn': usn,
      'department': department,
      'semester': semester,
      'profile_image': profileImage,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? usn,
    String? department,
    int? semester,
    String? profileImage,
    String? role,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      usn: usn ?? this.usn,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
