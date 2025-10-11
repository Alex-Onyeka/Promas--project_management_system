class ProjectClass {
  final String? uuid;
  final DateTime? createdAt;
  String name;
  String desc;
  double level;
  final int? companyId;
  List<String> employees;
  DateTime lastUpdate;

  ProjectClass({
    this.uuid,
    required this.createdAt,
    required this.lastUpdate,
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
      lastUpdate: DateTime.parse(json['last_update']),
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
      'created_at': createdAt?.toIso8601String(),
      'last_update': lastUpdate.toIso8601String(),
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
