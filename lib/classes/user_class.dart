class UserClass {
  final String? id;
  final DateTime? createdAt;
  final String name;
  final String email;
  final bool isAdmin;
  final String? jobTitle;
  int? companyId;

  UserClass({
    this.id,
    this.createdAt,
    required this.name,
    required this.email,
    required this.isAdmin,
    this.jobTitle,
    this.companyId,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      jobTitle: json['job_title'] ?? '',
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'created_at': createdAt?.toIso8601String(),
      'name': name,
      'email': email,
      'is_admin': isAdmin,
      'job_title': jobTitle,
      'company_id': companyId,
    };
  }
}
