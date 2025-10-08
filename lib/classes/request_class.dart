class RequestClass {
  final int? id;
  final DateTime? createdAt;
  final String userId;
  final int companyId;

  RequestClass({
    this.id,
    this.createdAt,
    required this.userId,
    required this.companyId,
  });

  factory RequestClass.fromJson(Map<String, dynamic> json) {
    return RequestClass(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'company_id': companyId};
  }
}
