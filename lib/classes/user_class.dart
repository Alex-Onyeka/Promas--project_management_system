import 'package:flutter/material.dart';

class UserClass {
  final String? id;
  final DateTime? createdAt;
  String name;
  String email;
  String? gitHubAlias;
  // bool isAdmin;
  String? jobTitle;
  int? companyId;
  int role;
  final GlobalKey key = GlobalKey();

  UserClass({
    this.id,
    this.createdAt,
    required this.name,
    required this.email,
    required this.gitHubAlias,
    // required this.isAdmin,
    this.jobTitle,
    this.companyId,
    required this.role,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gitHubAlias: json['git_hub_alias'] as String?,
      role: json['role'] as int,
      jobTitle: json['job_title'] ?? '',
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'created_at': createdAt?.toIso8601String(),
      'name': name,
      'email': email,
      'role': role,
      'job_title': jobTitle,
      'company_id': companyId,
      'git_hub_alias': gitHubAlias,
    };
  }

  String userRole() {
    switch (role) {
      case 1:
        return 'Developer';
      case 2:
        return 'Team Lead';
      case 3:
        return 'Project Manager';
      case 4:
        return 'Company Admin';
      case 5:
        return 'Super Admin';
      default:
        return 'Super Admin';
    }
  }

  bool isSuperAdmin() {
    if (role == 5) {
      return true;
    } else {
      return false;
    }
  }

  bool isCompanyAdmin() {
    if (role == 5 || role == 4) {
      return true;
    } else {
      return false;
    }
  }

  bool isProjectManager() {
    if (role == 5 || role == 4 || role == 3) {
      return true;
    } else {
      return false;
    }
  }

  bool isTeamLead() {
    if (role == 5 || role == 4 || role == 3 || role == 2) {
      return true;
    } else {
      return false;
    }
  }
}

class UserRoles {
  final String role;
  final int index;

  UserRoles({required this.role, required this.index});
}
