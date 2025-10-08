class BranchClass {
  final String uuid;
  final DateTime createdAt;
  final String? name;
  final String? desc;
  final String? projectId;
  final double? level;
  final List<String>? employees;
  final int? companyId;

  BranchClass({
    required this.uuid,
    required this.createdAt,
    this.name,
    this.desc,
    this.projectId,
    this.level,
    this.employees,
    this.companyId,
  });

  factory BranchClass.fromJson(Map<String, dynamic> json) {
    return BranchClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      desc: json['desc'],
      projectId: json['project_id'],
      level: (json['level'] != null)
          ? (json['level'] as num).toDouble()
          : null,
      employees: (json['employees'] != null)
          ? List<String>.from(json['employees'])
          : null,
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'uuid': uuid,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'desc': desc,
      'project_id': projectId,
      'level': level,
      'employees': employees,
      'company_id': companyId,
    };
  }
}
