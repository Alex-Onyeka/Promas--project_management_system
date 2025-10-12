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
              id: response.user!.id,
              name: name!,
              email: email,
              isAdmin: false,
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
    returnNav(context, listen: false).navigate(0);
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

  // /// Reset password via email
  // Future<void> resetPassword(String email) async {
  //   await _client.auth.resetPasswordForEmail(
  //     email,
  //     redirectTo: 'io.supabase.flutter://reset-callback/',
  //   );
  // }

  // /// Update password
  // Future<User?> updatePassword(String newPassword) async {
  //   final response = await _client.auth.updateUser(
  //     UserAttributes(password: newPassword),
  //   );
  //   return response.user;
  // }

  // /// Update user metadata (like name, jobTitle etc.)
  // Future<User?> updateMetadata(
  //   Map<String, dynamic> data,
  // ) async {
  //   final response = await _client.auth.updateUser(
  //     UserAttributes(data: data),
  //   );
  //   return response.user;
  // }
}
