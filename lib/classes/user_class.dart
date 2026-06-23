class UserClass {
  final String? id;
  final DateTime? createdAt;
  String name;
  String email;
  String? gitHubAlias;
  bool isAdmin;
  String? jobTitle;
  int? companyId;

  UserClass({
    this.id,
    this.createdAt,
    required this.name,
    required this.email,
    required this.gitHubAlias,
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
      gitHubAlias: json['git_hub_alias'] as String?,
      isAdmin: json['is_admin'],
      jobTitle: json['job_title'] ?? '',
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'created_at': createdAt?.toIso8601String(),
      'name': name,
      'email': email,
      'is_admin': isAdmin,
      'job_title': jobTitle,
      'company_id': companyId,
      'git_hub_alias': gitHubAlias,
    };
  }
}
