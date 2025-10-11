class BranchClass {
  final String? uuid;
  DateTime? createdAt;
  String name;
  String? desc;
  final String projectId;
  double level;
  List<String> employees;
  final int companyId;
  DateTime? lastUpdate;

  BranchClass({
    this.uuid,
    this.createdAt,
    this.lastUpdate,
    required this.name,
    this.desc,
    required this.projectId,
    required this.level,
    required this.employees,
    required this.companyId,
  });

  factory BranchClass.fromJson(Map<String, dynamic> json) {
    return BranchClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      lastUpdate: DateTime.parse(json['last_update']),
      name: json['name'],
      desc: json['desc'],
      projectId: json['project_id'],
      level: (json['level']) as double,
      employees: List<String>.from(json['employees']),
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'uuid': uuid,
      // 'created_at': createdAt.toIso8601String(),
      'last_update': lastUpdate?.toIso8601String(),
      'name': name,
      'desc': desc,
      'project_id': projectId,
      'level': level,
      'employees': employees,
      'company_id': companyId,
    };
  }
}
