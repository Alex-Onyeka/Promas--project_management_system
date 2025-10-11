import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BranchProvider extends ChangeNotifier {
  static final BranchProvider _instance =
      BranchProvider._internal();
  factory BranchProvider() => _instance;
  BranchProvider._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'branch';

  List<BranchClass> branches = [];

  // void addStaffToBranch(
  //   BranchClass branch,
  //   List<String> userIds,
  // ) {
  //   branch.employees.addAll(userIds);
  //   notifyListeners();
  // }

  // void removeStaffFromBranch(
  //   BranchClass branch,
  //   UserClass user,
  // ) {
  //   branch.employees.remove(user.id);
  //   notifyListeners();
  // }

  // void addBranchTemp(BranchClass branch) {
  //   branches.add(branch);
  //   print(branches.length);
  //   notifyListeners();
  // }

  // void deleteBranchTemp(BranchClass branch) {
  //   branches.remove(branch);
  //   print(branches.length);
  //   notifyListeners();
  // }

  List<UserClass> selectedStaffs = [];

  void selectNewStaff(UserClass staff) {
    selectedStaffs.add(staff);
    notifyListeners();
  }

  void removeSelectedStaff(UserClass staff) {
    selectedStaffs.remove(staff);
    notifyListeners();
  }

  void clearSelectedStaffs() {
    selectedStaffs.clear();
    notifyListeners();
  }

  void clearCache() {
    branches.clear();
    notifyListeners();
  }

  /// Create branch
  Future<BranchClass?> createBranch(
    BranchClass branch,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .insert(branch.toJson())
          .select()
          .single();
      print('Branch Created Successfully');
      branches.add(BranchClass.fromJson(response));
      await getBranchesByCompany();
      return BranchClass.fromJson(response);
    } catch (e) {
      print('Failed: ${e.toString()}');
      return null;
    }
  }

  /// Get branch by uuid
  Future<BranchClass?> getBranch(String uuid) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('uuid', uuid)
        .maybeSingle();

    if (response == null) return null;
    return BranchClass.fromJson(response);
  }

  Future<List<BranchClass>> getBranchesByEmployeeAndProject(
    String userId,
    String projectId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('project_id', projectId)
        .contains('employees', [userId]);

    return (response as List)
        .map((json) => BranchClass.fromJson(json))
        .toList();
  }

  /// Get all branches for a company
  Future<List<BranchClass>> getBranchesByCompany(
    // int companyId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq(
          'company_id',
          CompanyProvider().currentCompany!.id!,
        );

    List<BranchClass> tempBranches = (response as List)
        .map((json) => BranchClass.fromJson(json))
        .toList();

    branches = tempBranches;
    return branches;
  }

  /// Get all branches for a project
  Future<List<BranchClass>> getBranchesByProject(
    String projectId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('project_id', projectId);

    return (response as List)
        .map((json) => BranchClass.fromJson(json))
        .toList();
  }

  /// Update branch
  Future<BranchClass?> updateBranch(
    String uuid,
    BranchClass branch,
  ) async {
    try {
      branch.lastUpdate = DateTime.now();
      final response = await _client
          .from(_table)
          .update(branch.toJson())
          .eq('uuid', uuid)
          .select()
          .single();
      updateBranchTemp(BranchClass.fromJson(response));
      await getBranchesByCompany();
      print('Branch updated Success');
      return BranchClass.fromJson(response);
    } catch (e) {
      print('Branch updated Failed: ${e.toString()}');
      return null;
    }
  }

  void updateBranchTemp(BranchClass branch) {
    var edit = branches
        .where((br) => br.uuid == branch.uuid)
        .toList();
    edit.first.name = branch.name;
    edit.first.desc = branch.desc;
    edit.first.employees = branch.employees;
    edit.first.level = branch.level;
    edit.first.lastUpdate = branch.lastUpdate;
    print(branches.length);
    notifyListeners();
  }

  // Add Staff to Branch
  Future<void> addStaffToBranch(
    String branchUuid,
    List<String> employees,
  ) async {
    try {
      await _client.rpc(
        'add_employees_to_branch',
        params: {
          'p_branch': branchUuid,
          'p_employees': employees,
        },
      );
      var bran = branches.where(
        (br) => br.uuid == branchUuid,
      );
      bran.first.employees.addAll(employees);
      notifyListeners();
      await getBranchesByCompany();
      print('Staff Added Successfully');
    } catch (e) {
      print('Failed: ${e.toString()}');
      ;
    }
  }

  Future<void> removeStaffFromBranch(
    String branchUuid,
    String employee,
  ) async {
    try {
      await _client.rpc(
        'remove_employee_from_branch',
        params: {
          'p_branch': branchUuid,
          'p_employee': employee,
        },
      );
      var bran = branches.where(
        (br) => br.uuid == branchUuid,
      );
      bran.first.employees.remove(employee);
      notifyListeners();
      await getBranchesByCompany();
      print('Staff Removes Successfully');
    } catch (e) {
      print('Failed: ${e.toString()}');
    }
  }

  /// Delete branch
  Future<void> deleteBranch(String uuid) async {
    try {
      await _client.from(_table).delete().eq('uuid', uuid);
      branches.removeWhere((branch) => branch.uuid == uuid);
      notifyListeners();
      print('Branch Delete Successfully');
      await getBranchesByCompany();
    } catch (e) {
      print('Delete Failed: ${e.toString()}');
    }
  }
}
