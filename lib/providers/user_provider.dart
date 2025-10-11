import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'users';

  UserProvider._internal();

  static final UserProvider _instance =
      UserProvider._internal();

  factory UserProvider() => _instance;

  Future<UserClass?> createUser(UserClass user) async {
    try {
      final response = await _client
          .from(_table)
          .insert(user.toJson())
          .select()
          .single();
      currentUser = UserClass.fromJson(response);
      print('User Created Successfully');
      return currentUser;
    } catch (e) {
      print('User Creation Failed: ${e.toString()}');
      return null;
    }
  }

  List<UserClass> users = [
    UserClass(
      id: 'No 1',
      companyId: CompanyProvider().currentCompany?.id,
      name: 'Alex',
      email: 'alex@gmail.com',
      isAdmin: false,
    ),
    UserClass(
      companyId: CompanyProvider().currentCompany?.id,
      id: 'No 2',
      name: 'Benjamin',
      email: 'olnygrmii22@gmail.com',
      isAdmin: false,
    ),
  ];
  UserClass? currentUser;

  void clearCache() {
    users.clear();
    currentUser = null;
    notifyListeners();
  }

  Future<UserClass?> getCurrentUser() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', AuthService().currentUser!.id)
          .maybeSingle();

      if (response == null) {
        print('Company Not Gotten');
        return null;
      }

      UserClass userTemp = UserClass.fromJson(response);
      print(userTemp.name);
      currentUser = userTemp;
      notifyListeners();
      print('User Gotten: ${currentUser?.name}');
      return currentUser;
    } catch (e) {
      print('Getting User Failed: ${e.toString()}');
      return null;
    }
  }

  Future<UserClass?> getUser(String id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return currentUser;
  }

  /// Get all users
  Future<List<UserClass>> getAllCompanyUsers() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq(
            'company_id',
            CompanyProvider().currentCompany!.id!,
          );

      List<UserClass> usersTemp = (response as List)
          .map((json) => UserClass.fromJson(json))
          .toList();

      users = usersTemp
          .where((us) => us.id != currentUser?.id)
          .toList();
      print('Users Gotten Success');
      notifyListeners();
      return users;
    } catch (e) {
      print('Users Gotten Failed: ${e.toString()}');
      return [];
    }
  }

  /// Update a user
  Future<UserClass?> updateUser(UserClass user) async {
    try {
      final response = await _client
          .from(_table)
          .update(user.toJson())
          .eq('id', user.id!)
          .select()
          .single();
      print('User Update Success');
      try {
        await getAllCompanyUsers();
      } catch (e) {
        print('Getting all Users Error: ${e.toString()}');
      }

      return UserClass.fromJson(response);
    } catch (e) {
      print('User Update Failed: ${e.toString()}');
      return null;
    }
  }

  /// Add User To A Company
  Future<UserClass?> addUserToCompany(String userId) async {
    try {
      final response = await _client
          .from(_table)
          .update({
            'company_id':
                CompanyProvider().currentCompany!.id!,
          })
          .eq('id', userId)
          .select()
          .single();
      print('User Update Success');
      try {
        await RequestsProvider().deleteRequest(userId);
        await getAllCompanyUsers();
      } catch (e) {
        print('Getting all Users Error: ${e.toString()}');
      }

      return UserClass.fromJson(response);
    } catch (e) {
      print('User Update Failed: ${e.toString()}');
      return null;
    }
  }

  /// Remove User To A Company
  Future<UserClass?> removeUserToCompany(
    String userId,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .update({'company_id': null})
          .eq('id', userId)
          .select()
          .single();
      print('User Update Success');
      try {
        await getAllCompanyUsers();
      } catch (e) {
        print('Getting all Users Error: ${e.toString()}');
      }

      return UserClass.fromJson(response);
    } catch (e) {
      print('User Update Failed: ${e.toString()}');
      return null;
    }
  }

  /// Edit User is Admin
  Future<UserClass?> editUserIdAdmin(
    String userId,
    bool isAdmin,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .update({'is_admin': isAdmin})
          .eq('id', userId)
          .select()
          .single();
      print('User Update Success');
      try {
        await getAllCompanyUsers();
      } catch (e) {
        print('Getting all Users Error: ${e.toString()}');
      }

      return UserClass.fromJson(response);
    } catch (e) {
      print('User Update Failed: ${e.toString()}');
      return null;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String id) async {
    await _client.from(_table).delete().eq('id', id);
    await getAllCompanyUsers();
  }
}
