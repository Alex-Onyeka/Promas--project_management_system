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

  void addBranchTemp(BranchClass branch) {
    branches.add(branch);
    print(branches.length);
    notifyListeners();
  }

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
    final response = await _client
        .from(_table)
        .insert(branch.toJson())
        .select()
        .single();
    await getBranchesByCompany();

    return BranchClass.fromJson(response);
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
    branch.lastUpdate = DateTime.now();
    final response = await _client
        .from(_table)
        .update(branch.toJson())
        .eq('uuid', uuid)
        .select()
        .single();
    await getBranchesByCompany();

    return BranchClass.fromJson(response);
  }

  /// Delete branch
  Future<void> deleteBranch(String uuid) async {
    await _client.from(_table).delete().eq('uuid', uuid);
  }
}
