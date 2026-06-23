import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/main.dart';
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

  bool isLoading = false;
  void toggleLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addSingleProject({required ProjectClass project}) {
    try {
      var res = projectsMain.where(
        (item) => item.uuid == project.uuid,
      );
      if (res.isEmpty) {
        projectsMain.add(project);
      } else {
        var pro = res.first;
        projectsMain.remove(pro);
      }
      projectsMain.add(project);
      projectsMain.sort(
        (a, b) => b.createdAt!.compareTo(a.createdAt!),
      );
      notifyListeners();
    } catch (e) {
      print('Error Adding Single Project: ${e.toString()}');
    }
  }

  void clearCache() {
    projectsMain.clear();
    notifyListeners();
  }

  String projectGithubName({required String projectUrl}) {
    try {
      if (projectUrl.contains('/')) {
        return projectUrl.split('/').last;
      } else {
        return projectUrl;
      }
    } catch (e) {
      print('Error Occoured: ${e.toString()}');
      return projectUrl;
    }
  }

  String projectAuthorName({required String projectUrl}) {
    try {
      if (projectUrl.contains('/')) {
        return projectUrl.split(
          '/',
        )[projectUrl.split('/').length - 2];
      } else {
        return projectUrl;
      }
    } catch (e) {
      print('Error Occourd: ${e.toString()}');
      return projectUrl;
    }
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
      try {
        await getSingleProject(
          projectUuid: ProjectClass.fromJson(
            response,
          ).uuid!,
        );
      } catch (e) {
        print(
          'Error Fetching Single Project Inside Create Project Function: ${e.toString()}',
        );
      }
      print('Project Created Successfully');
      return ProjectClass.fromJson(response);
    } catch (e) {
      print('Project Creation failed: ${e.toString()}');
      return null;
    }
  }

  /// Get all projects
  Future<List<ProjectClass>>
  getAllProjectsByCompany() async {
    try {
      toggleLoading(true);
      // projectsMain.clear();
      if (returnUser().currentUser?.isAdmin == true) {
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
        projectsMain.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt!),
        );
        notifyListeners();
        await BranchProvider().getBranchesByCompany();
      } else {
        final response = await _client.rpc(
          'get_projects_for_employee',
          params: {
            'p_user_id': returnUser().currentUser?.id,
          },
        );
        List<ProjectClass> tempProjects = (response as List)
            .map((json) => ProjectClass.fromJson(json))
            .toList();

        projectsMain = tempProjects;
        projectsMain.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt!),
        );
        notifyListeners();
        await BranchProvider().getBranchesByCompany();
      }
      returnCommit().clearCache();
      for (var pro in projectsMain) {
        if (pro.githubUrl != null) {
          await returnCommit().fetchCommits(
            owner: projectAuthorName(
              projectUrl: pro.githubUrl ?? '',
            ),
            repo: projectGithubName(
              projectUrl: pro.githubUrl ?? '',
            ),
          );
        }
      }
      print(
        'Gotten All Company Projects: ${projectsMain.length}',
      );
      toggleLoading(false);
      return projectsMain;
    } catch (e) {
      print('Error Fetching Projects: ${e.toString()}');
      if (e is DioException) {
        print(e.response?.data);
      }
      toggleLoading(false);
      return [];
    }
  }

  /// Get all projects
  Future<void> getSingleProject({
    required String projectUuid,
  }) async {
    try {
      toggleLoading(true);
      Map<String, dynamic>? response = await _client
          .from(_table)
          .select()
          .eq('uuid', projectUuid)
          .maybeSingle();
      if (response == null) {
        print('Project Not Found');
        return;
      }

      ProjectClass temp = ProjectClass.fromJson(response);

      addSingleProject(project: temp);
      notifyListeners();
      if (temp.githubUrl != null) {
        await returnCommit().fetchCommits(
          owner: projectAuthorName(
            projectUrl: temp.githubUrl ?? '',
          ),
          repo: projectGithubName(
            projectUrl: temp.githubUrl ?? '',
          ),
        );
      }
      toggleLoading(false);
      print('Project Gotten Successfully');
      notifyListeners();
    } catch (e) {
      toggleLoading(false);
      print(
        'Error Fetching Single Project: ${e.toString()}',
      );
      if (e is DioException) {
        print(e.response?.data);
      }
    }
  }

  /// Update a project
  Future<ProjectClass?> updateProject(
    String uuid,
    ProjectClass project,
  ) async {
    try {
      // project.lastUpdate = DateTime.now();
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
    // edit.first.lastUpdate = project.lastUpdate;
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

  List<ProjectClass> projects() {
    if (projectsMain.length >= 4) {
      return projectsMain.sublist(0, 4);
    } else {
      return projectsMain;
    }
  }
}
