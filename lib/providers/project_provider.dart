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

  List<ProjectClass> projectsMain = [];
  void clearCache() {
    projectsMain.clear();
    notifyListeners();
  }

  /// Create a new project
  Future<ProjectClass?> createProject(
    ProjectClass project,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .insert(project.toJson())
          .select()
          .single();
      projectsMain.add(ProjectClass.fromJson(response));
      notifyListeners();
      await getAllProjectsByCompany();
      print('Project Created Successfully');
      return ProjectClass.fromJson(response);
    } catch (e) {
      print('Project Creation failed: ${e.toString()}');
      return null;
    }
  }

  // /// Read/Get project by uuid
  // Future<ProjectClass?> getProject(String uuid) async {
  //   final response = await _client
  //       .from(_table)
  //       .select()
  //       .eq('uuid', uuid)
  //       .maybeSingle();

  //   if (response == null) return null;
  //   return ProjectClass.fromJson(response);
  // }

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

    projectsMain = tempProjects;
    notifyListeners();
    await BranchProvider().getBranchesByCompany();
    return projectsMain;
  }

  // //
  // //
  // Future<List<ProjectClass>>
  // getProjectsByEmployeeAndCompany(
  //   String userId,
  //   int companyId,
  // ) async {
  //   final response = await _client
  //       .from(_table)
  //       .select()
  //       .eq('company_id', companyId)
  //       .contains('employees', [userId]);

  //   return (response as List)
  //       .map((json) => ProjectClass.fromJson(json))
  //       .toList();
  // }

  // /// Get all projects
  // Future<List<ProjectClass>> getAllProjects() async {
  //   final response = await _client.from(_table).select();
  //   return (response as List)
  //       .map((json) => ProjectClass.fromJson(json))
  //       .toList();
  // }

  /// Update a project
  Future<ProjectClass?> updateProject(
    String uuid,
    ProjectClass project,
  ) async {
    try {
      project.lastUpdate = DateTime.now();
      final response = await _client
          .from(_table)
          .update(project.toJson())
          .eq('uuid', uuid)
          .select()
          .single();
      updateProjectCache(ProjectClass.fromJson(response));
      await getAllProjectsByCompany();
      print('Project Updated Success');
      return ProjectClass.fromJson(response);
    } catch (e) {
      print('Update Failed: ${e.toString()}');
      return null;
    }
  }

  void updateProjectCache(ProjectClass project) {
    var edit = projectsMain
        .where((pro) => pro.uuid == project.uuid)
        .toList();
    edit.first.name = project.name;
    edit.first.desc = project.desc;
    edit.first.lastUpdate = project.lastUpdate;
    notifyListeners();
  }

  /// Delete a project
  Future<void> deleteProject(String uuid) async {
    try {
      await _client.from(_table).delete().eq('uuid', uuid);
      projectsMain.removeWhere((pro) => pro.uuid == uuid);
      notifyListeners();
      await getAllProjectsByCompany();
      print('Project Deleted Succesffuly');
    } catch (e) {
      print('Delete Failed: ${e.toString()}');
    }
  }

  // List<ProjectClass> mainProjects = [
  //   // ProjectClass(
  //   //   uuid: 'No 0',
  //   //   createdAt: DateTime.now(),
  //   //   lastUpdate: DateTime.now(),
  //   //   name: 'Stockall Application Development',
  //   //   desc: 'An Inventory Management System',
  //   //   level: 0,
  //   //   employees: [],
  //   //   companyId: CompanyProvider().currentCompany!.id,
  //   // ),
  //   // ProjectClass(
  //   //   uuid: 'No 1',
  //   //   createdAt: DateTime.now(),
  //   //   lastUpdate: DateTime.now(),
  //   //   name: 'Promas Project Management System',
  //   //   desc:
  //   //       'An Project Management System, designed for company staff relationship and management. Project Management...',
  //   //   level: 0,
  //   //   employees: [],
  //   //   companyId: CompanyProvider().currentCompany!.id,
  //   // ),
  //   // ProjectClass(
  //   //   uuid: 'No 2',
  //   //   createdAt: DateTime.now(),
  //   //   lastUpdate: DateTime.now(),
  //   //   name: 'Social Media Platform',
  //   //   desc:
  //   //       'An Digital Management Platform where users can share posts and create social experiences.',
  //   //   level: 0,
  //   //   employees: [],
  //   //   companyId: CompanyProvider().currentCompany!.id,
  //   // ),
  // ];

  List<ProjectClass> projects() {
    if (projectsMain.length >= 4) {
      return projectsMain.sublist(0, 4);
    } else {
      return projectsMain;
    }
  }

  // void addProject(ProjectClass project) {
  //   print('Adding Project ${project.name} : ');
  //   mainProjects.add(project);
  //   print(
  //     'Added Project ${project.name} : ${mainProjects.length}',
  //   );
  //   notifyListeners();
  // }

  // void deleteProject(ProjectClass project) {
  //   projectsMain.removeWhere(
  //     (pro) => pro.uuid == project.uuid,
  //   );
  //   notifyListeners();
  // }
}
