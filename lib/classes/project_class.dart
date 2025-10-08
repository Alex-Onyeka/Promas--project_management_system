class ProjectClass {
  final String uuid;
  final DateTime createdAt;
  final String name;
  final String desc;
  final double level;
  final int? companyId;
  final List<String> employees;

  ProjectClass({
    required this.uuid,
    required this.createdAt,
    required this.name,
    required this.desc,
    required this.level,
    this.companyId,
    required this.employees,
  });

  /// From JSON (Supabase → Dart)
  factory ProjectClass.fromJson(Map<String, dynamic> json) {
    return ProjectClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      level: (json['level'] as num?)?.toDouble() ?? 0.0,
      companyId: json['company_id'],
      employees: json['employees'],
    );
  }

  /// To JSON (Dart → Supabase)
  Map<String, dynamic> toJson() {
    return {
      // 'uuid': uuid,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'desc': desc,
      'level': level,
      'company_id': companyId,
      'employees': employees,
    };
  }

  // /// Optional: copyWith for partial updates
  // ProjectClass copyWith({
  //   String? uuid,
  //   DateTime? createdAt,
  //   String? name,
  //   String? desc,
  //   double? level,
  //   int? companyId,
  // }) {
  //   return ProjectClass(
  //     uuid: uuid ?? this.uuid,
  //     createdAt: createdAt ?? this.createdAt,
  //     name: name ?? this.name,
  //     desc: desc ?? this.desc,
  //     level: level ?? this.level,
  //     companyId: companyId ?? this.companyId,
  //   );
  // }
}
