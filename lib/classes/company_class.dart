class CompanyClass {
  final int? id;
  final DateTime? createdAt;
  String name;
  String desc;
  final String? email;
  String? token;

  CompanyClass({
    this.id,
    this.createdAt,
    required this.name,
    required this.desc,
    this.token,
    this.email,
  });

  /// Factory: from JSON (Supabase → Dart)
  factory CompanyClass.fromJson(Map<String, dynamic> json) {
    return CompanyClass(
      id: json['id'] as int?,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }

  /// To JSON (Dart → Supabase)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'created_at': createdAt.toIso8601String(),
      'name': name,
      'desc': desc,
      'email': email,
      'token': token,
    };
  }

  /// Optional: copyWith for updates
  CompanyClass copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? desc,
    String? token,
  }) {
    return CompanyClass(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      token: token ?? this.token,
    );
  }
}
