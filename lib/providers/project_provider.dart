import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'project';

  ProjectProvider._internal();
  ProjectProvider get projectProvider => ProjectProvider();

  static final ProjectProvider _instance =
      ProjectProvider._internal();

  factory ProjectProvider() => _instance;

  List<ProjectClass> projects = [];
  void clearCache() {
    projects.clear();
    notifyListeners();
  }

  /// Create a new project
  Future<ProjectClass?> createProject(
    ProjectClass project,
  ) async {
    final response = await _client
        .from(_table)
        .insert(project.toJson())
        .select()
        .single();
    await getAllProjectsByCompany();

    return ProjectClass.fromJson(response);
  }

  /// Read/Get project by uuid
  Future<ProjectClass?> getProject(String uuid) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('uuid', uuid)
        .maybeSingle();

    if (response == null) return null;
    return ProjectClass.fromJson(response);
  }

  /// Get all projects
  Future<List<ProjectClass>>
  getAllProjectsByCompany() async {
    final response = await _client
        .from(_table)
        .select()
        .eq(
          'company_id',
          CompanyProvider().currentCompany!.id!,
        );

    List<ProjectClass> tempProjects = (response as List)
        .map((json) => ProjectClass.fromJson(json))
        .toList();

    projects = tempProjects;
    notifyListeners();
    await BranchProvider().getBranchesByCompany();
    return projects;
  }

  //
  //
  Future<List<ProjectClass>>
  getProjectsByEmployeeAndCompany(
    String userId,
    int companyId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('company_id', companyId)
        .contains('employees', [userId]);

    return (response as List)
        .map((json) => ProjectClass.fromJson(json))
        .toList();
  }

  /// Get all projects for a specific company
  Future<List<ProjectClass>> getAllProjects() async {
    final response = await _client.from(_table).select();
    return (response as List)
        .map((json) => ProjectClass.fromJson(json))
        .toList();
  }

  /// Update a project
  Future<ProjectClass?> updateProject(
    String uuid,
    ProjectClass project,
  ) async {
    final response = await _client
        .from(_table)
        .update(project.toJson())
        .eq('uuid', uuid)
        .select()
        .single();

    await getAllProjectsByCompany();

    return ProjectClass.fromJson(response);
  }

  /// Delete a project
  Future<void> deleteProject(String uuid) async {
    await _client.from(_table).delete().eq('uuid', uuid);
    await getAllProjectsByCompany();
  }
}
