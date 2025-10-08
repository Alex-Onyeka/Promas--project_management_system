import 'package:flutter/material.dart';
import 'package:promas/classes/company_class.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'company';

  CompanyProvider._internal();

  static final CompanyProvider _instance =
      CompanyProvider._internal();

  CompanyProvider get companyProvider => CompanyProvider();

  factory CompanyProvider() => _instance;
  List<CompanyClass> companies = [];
  CompanyClass? currentCompany;

  void clearChache() {
    companies.clear();
    currentCompany = null;
    notifyListeners();
  }

  Future<CompanyClass?> createCompany(
    CompanyClass company,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .insert(company.toJson())
          .select()
          .single();
      print('Company Creation Success');
      currentCompany = CompanyClass.fromJson(response);
      notifyListeners();
      return CompanyClass.fromJson(response);
    } catch (e) {
      print('Company Creation Failed: ${e.toString()}');
      return null;
    }
  }

  /// Read/Get company by id
  Future<CompanyClass?> getCompany(int id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    CompanyClass companyTemp = CompanyClass.fromJson(
      response,
    );
    return companyTemp;
  }

  /// Read/Get Current Company by id
  Future<CompanyClass?> getMyCompany() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq(
            'id',
            UserProvider().currentUser?.companyId ?? 0,
          )
          .maybeSingle();

      if (response == null) {
        print('Company Not Gotten');
        return null;
      }
      CompanyClass companyTemp = CompanyClass.fromJson(
        response,
      );
      currentCompany = companyTemp;
      notifyListeners();
      print('Company Gotten');
      return currentCompany;
    } catch (e) {
      print('Get Company Failed: ${e.toString()}');
      return null;
    }
  }

  /// Get all companies
  Future<List<CompanyClass>> getAllCompanies() async {
    final response = await _client.from(_table).select();

    List<CompanyClass> companiesTemp = (response as List)
        .map((json) => CompanyClass.fromJson(json))
        .toList();
    companies = companiesTemp;
    notifyListeners();
    return companies;
  }

  /// Update a company
  Future<CompanyClass?> updateCompany(
    int id,
    CompanyClass company,
  ) async {
    final response = await _client
        .from(_table)
        .update(company.toJson())
        .eq('id', id)
        .select()
        .single();
    await getMyCompany();

    return CompanyClass.fromJson(response);
  }

  /// Delete a company
  Future<void> deleteCompany(int id) async {
    await _client.from(_table).delete().eq('id', id);
    await getMyCompany();
  }
}
