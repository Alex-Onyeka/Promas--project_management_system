class RequestClass {
  final int? id;
  final DateTime? createdAt;
  String? userId;
  final int companyId;
  final String userName;
  final String userEmail;

  RequestClass({
    this.id,
    this.createdAt,
    this.userId,
    required this.companyId,
    required this.userName,
    required this.userEmail,
  });

  factory RequestClass.fromJson(Map<String, dynamic> json) {
    return RequestClass(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      companyId: json['company_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'company_id': companyId,
      'user_email': userEmail,
      'user_name': userName,
    };
  }
}
