import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/project_provider.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance =
      AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Sign up with email + password
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required String gitHubAlias,
    String? name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      print(response.user?.id);
      if (response.user != null) {
        try {
          await UserProvider().createUser(
            UserClass(
              gitHubAlias: gitHubAlias,
              id: response.user!.id,
              name: name!,
              email: email,
              role: 1,
            ),
          );
        } catch (e) {
          print(
            'Error Creating User Account: ${e.toString()}',
          );
        }
      }

      return response;
    } catch (e) {
      print('Error Signing Up: ${e.toString()}');
      return null;
    }
  }

  /// Sign in with email + password
  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth
          .signInWithPassword(
            email: email,
            password: password,
          );
      return response;
    } catch (e) {
      print('Signing In Failed: ${e.toString()}');
      return null;
    }
  }

  /// Sign in with magic link
  Future<void> signInWithMagicLink(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo:
          'io.supabase.flutter://login-callback/',
    );
  }

  /// Sign out
  Future<void> signOut({
    required BuildContext context,
  }) async {
    ProjectProvider().clearCache();
    BranchProvider().clearCache();
    returnNav().navigate(0);
    await _client.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BasePage();
          },
        ),
      );
      UserProvider().clearCache();
      CompanyProvider().clearChache();
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event);

  Future<int> deleteAuthAccount() async {
    try {
      // 1️⃣ Get current user session
      final session =
          Supabase.instance.client.auth.currentSession;

      if (session == null) {
        print("User is not signed in");
        return 0;
      }

      // 2️⃣ Call the Edge Function with Authorization header
      final response = await Supabase
          .instance
          .client
          .functions
          .invoke(
            'delete_own_account',
            headers: {
              'Authorization':
                  'Bearer ${session.accessToken}',
            },
          );

      // 3️⃣ Safely cast the response data
      final data = response.data as Map<String, dynamic>?;

      // 4️⃣ Handle errors returned by the function
      if (response.status != 200) {
        print(
          'Error deleting account: ${response.data.toString()}',
        );
        return 0;
      }

      if (data != null && data['error'] != null) {
        print('Error deleting account: ${data['error']}');
        return 0;
      }

      // 5️⃣ Success: delete completed
      if (data != null && data['success'] == true) {
        print('Account deleted successfully');

        // Optional: sign out the user immediately
        await Supabase.instance.client.auth.signOut();

        return 1;
      }

      // 6️⃣ Unknown error fallback
      print('Unknown error deleting account');
      return 0;
    } catch (e) {
      print("Exception deleting user: ${e.toString()}");
      return 0;
    }
  }
}
