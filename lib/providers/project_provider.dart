import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';

class ProjectProvider extends ChangeNotifier {
  // final SupabaseClient _client = Supabase.instance.client;
  // final String _table = 'project';

  ProjectProvider._internal();
  ProjectProvider get projectProvider => ProjectProvider();

  static final ProjectProvider _instance =
      ProjectProvider._internal();

  factory ProjectProvider() => _instance;

  // List<ProjectClass> projects = [];
  void clearCache() {
    mainProjects.clear();
    notifyListeners();
  }

  // /// Create a new project
  // Future<ProjectClass?> createProject(
  //   ProjectClass project,
  // ) async {
  //   final response = await _client
  //       .from(_table)
  //       .insert(project.toJson())
  //       .select()
  //       .single();
  //   await getAllProjectsByCompany();

  //   return ProjectClass.fromJson(response);
  // }

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

  // /// Get all projects
  // Future<List<ProjectClass>>
  // getAllProjectsByCompany() async {
  //   final response = await _client
  //       .from(_table)
  //       .select()
  //       .eq(
  //         'company_id',
  //         CompanyProvider().currentCompany!.id!,
  //       );

  //   List<ProjectClass> tempProjects = (response as List)
  //       .map((json) => ProjectClass.fromJson(json))
  //       .toList();

  //   projects = tempProjects;
  //   notifyListeners();
  //   await BranchProvider().getBranchesByCompany();
  //   return projects;
  // }

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

  // /// Get all projects for a specific company
  // Future<List<ProjectClass>> getAllProjects() async {
  //   final response = await _client.from(_table).select();
  //   return (response as List)
  //       .map((json) => ProjectClass.fromJson(json))
  //       .toList();
  // }

  // /// Update a project
  // Future<ProjectClass?> updateProject(
  //   String uuid,
  //   ProjectClass project,
  // ) async {
  //   project.lastUpdate = DateTime.now();
  //   final response = await _client
  //       .from(_table)
  //       .update(project.toJson())
  //       .eq('uuid', uuid)
  //       .select()
  //       .single();

  //   await getAllProjectsByCompany();

  //   return ProjectClass.fromJson(response);
  // }

  // /// Delete a project
  // Future<void> deleteProject(String uuid) async {
  //   await _client.from(_table).delete().eq('uuid', uuid);
  //   await getAllProjectsByCompany();
  // }

  List<ProjectClass> mainProjects = [
    // ProjectClass(
    //   uuid: 'No 0',
    //   createdAt: DateTime.now(),
    //   lastUpdate: DateTime.now(),
    //   name: 'Stockall Application Development',
    //   desc: 'An Inventory Management System',
    //   level: 0,
    //   employees: [],
    //   companyId: CompanyProvider().currentCompany!.id,
    // ),
    // ProjectClass(
    //   uuid: 'No 1',
    //   createdAt: DateTime.now(),
    //   lastUpdate: DateTime.now(),
    //   name: 'Promas Project Management System',
    //   desc:
    //       'An Project Management System, designed for company staff relationship and management. Project Management...',
    //   level: 0,
    //   employees: [],
    //   companyId: CompanyProvider().currentCompany!.id,
    // ),
    // ProjectClass(
    //   uuid: 'No 2',
    //   createdAt: DateTime.now(),
    //   lastUpdate: DateTime.now(),
    //   name: 'Social Media Platform',
    //   desc:
    //       'An Digital Management Platform where users can share posts and create social experiences.',
    //   level: 0,
    //   employees: [],
    //   companyId: CompanyProvider().currentCompany!.id,
    // ),
  ];

  List<ProjectClass> projects() {
    if (mainProjects.length >= 4) {
      return mainProjects.sublist(0, 4);
    } else {
      return mainProjects;
    }
  }

  void addProject(ProjectClass project) {
    print('Adding Project ${project.name} : ');
    mainProjects.add(project);
    print(
      'Added Project ${project.name} : ${mainProjects.length}',
    );
    notifyListeners();
  }

  void deleteProject(ProjectClass project) {
    mainProjects.removeWhere(
      (pro) => pro.uuid == project.uuid,
    );
    notifyListeners();
  }

  void updateProject(ProjectClass project) {
    var edit = mainProjects
        .where((pro) => pro.uuid == project.uuid)
        .toList();
    edit.first.name = project.name;
    edit.first.desc = project.desc;
    edit.first.lastUpdate = project.lastUpdate;
    edit.first.level = project.level;
    edit.first.employees = project.employees;
    notifyListeners();
  }
}
