import 'package:flutter/material.dart';

class Chats {
  String uuid;
  DateTime? createdAt;
  String userId;
  String message;
  String? chatId;
  final int companyId;
  String? projectId;
  String? branchId;
  String? userName;
  String? replyId;
  String? replyUserName;
  String? replyMessage;
  final GlobalKey key = GlobalKey();

  Chats({
    required this.uuid,
    required this.userId,
    this.createdAt,
    required this.message,
    this.chatId,
    required this.companyId,
    this.projectId,
    this.branchId,
    required this.userName,
    this.replyId,
    this.replyUserName,
    this.replyMessage,
  });

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      uuid: json['uuid'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      chatId: json['chat_id'],
      companyId: json['company_id'] as int,
      projectId: json['project_id'] as String?,
      branchId: json['branch_id'] as String?,
      userName: json['user_name'] as String?,
      replyId: json['reply_id'] as String?,
      replyUserName: json['reply_user_name'] as String?,
      replyMessage: json['reply_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'message': message,
      'chat_id': chatId,
      'company_id': companyId,
      'project_id': projectId,
      'branch_id': branchId,
      'user_name': userName,
      'reply_id': replyId,
      'reply_user_name': replyUserName,
      'reply_message': replyMessage,
    };
  }
}
