class ProjectClass {
  final String? uuid;
  final DateTime? createdAt;
  String name;
  String desc;
  final int? companyId;
  DateTime lastUpdate;
  final String? githubUrl;

  ProjectClass({
    this.uuid,
    required this.createdAt,
    required this.lastUpdate,
    required this.name,
    required this.desc,
    this.companyId,
    this.githubUrl,
  });

  /// From JSON (Supabase → Dart)
  factory ProjectClass.fromJson(Map<String, dynamic> json) {
    return ProjectClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      lastUpdate: DateTime.parse(json['last_update']),
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      companyId: json['company_id'],
      githubUrl: json['github_url'] as String?,
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
      'company_id': companyId,
      'github_url': githubUrl,
    };
  }

  ProjectClass copyWith({
    String? uuid,
    DateTime? createdAt,
    String? name,
    String? desc,
    int? companyId,
    DateTime? lastUpdate,
    String? githubUrl,
  }) {
    return ProjectClass(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      companyId: companyId ?? this.companyId,
      githubUrl: githubUrl ?? this.githubUrl,
    );
  }
}
