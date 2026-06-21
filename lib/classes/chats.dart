class Chats {
  String uuid;
  DateTime? createdAt;
  String message;
  String? chatId;
  final int companyId;
  String? projectId;
  String? branchId;

  Chats({
    required this.uuid,
    this.createdAt,
    required this.message,
    this.chatId,
    required this.companyId,
    this.projectId,
    this.branchId,
  });

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      uuid: json['uuid'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      message: json['message'] ?? '',
      chatId: json['chat_id'],
      companyId: json['company_id'] as int,
      projectId: json['project_id'] as String?,
      branchId: json['branch_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'created_at': createdAt?.toIso8601String(),
      'message': message,
      'chat_id': chatId,
      'company_id': companyId,
      'project_id': projectId,
      'branch_id': branchId,
    };
  }
}
