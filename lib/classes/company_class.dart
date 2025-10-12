class CompanyClass {
  final int? id;
  final DateTime? createdAt;
  String name;
  String desc;
  final String? email;

  CompanyClass({
    this.id,
    this.createdAt,
    required this.name,
    required this.desc,
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
    };
  }

  /// Optional: copyWith for updates
  CompanyClass copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? desc,
  }) {
    return CompanyClass(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      desc: desc ?? this.desc,
    );
  }
}
