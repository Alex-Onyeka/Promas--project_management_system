import 'package:flutter/material.dart';
import 'package:promas/classes/request_class.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestsProvider extends ChangeNotifier {
  static final RequestsProvider _instance =
      RequestsProvider._internal();
  factory RequestsProvider() => _instance;
  RequestsProvider._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'requests';

  List<RequestClass> requests = [];
  RequestClass? currentRequest;

  void clearCache() {
    requests.clear();
    notifyListeners();
  }

  /// Create Request
  Future<RequestClass?> createRequest(
    RequestClass request,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .insert(request.toJson())
          .select()
          .single();
      // await getRequestsByCompany();
      print('Request Created Successfully');
      currentRequest = RequestClass.fromJson(response);
      notifyListeners();
      return RequestClass.fromJson(response);
    } catch (e) {
      print('Request Creation Failed: ${e.toString()}');
      return null;
    }
  }

  /// Get Request by id
  Future<RequestClass?> getRequest(int id) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      print(
        'Request Gotten: ${RequestClass.fromJson(response).id}',
      );
      return RequestClass.fromJson(response);
    } catch (e) {
      print('Faild: ${e.toString()}');
      return null;
    }
  }

  /// Get Request by id
  Future<RequestClass?> getRequestByUser(
    String userId,
  ) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        print('No Requests Found');
        return null;
      }
      ;
      print(
        'Request Gotten: ${RequestClass.fromJson(response).id}',
      );
      currentRequest = RequestClass.fromJson(response);
      notifyListeners();
      return RequestClass.fromJson(response);
    } catch (e) {
      print('Faild: ${e.toString()}');
      return null;
    }
  }

  bool isLoaded = false;

  Future<List<RequestClass>> getRequestsByCompany() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq(
            'company_id',
            CompanyProvider().currentCompany!.id!,
          );

      requests = (response as List)
          .map((json) => RequestClass.fromJson(json))
          .toList();
      isLoaded = true;
      notifyListeners();
      print('Requests Gotten: ${requests.length}');
      return requests;
    } catch (e) {
      print('Requests Getting Failed: ${e.toString()}');
      return [];
    }
  }

  /// Delete Request
  Future<void> declineOrAcceptRequest(String userId) async {
    try {
      await _client
          .from(_table)
          .update({'user_id': null})
          .eq('user_id', userId);
      var req = requests
          .where((req) => req.userId == userId)
          .first;
      req.userId = null;
      print('Request Declined Successfully');
      notifyListeners();
    } catch (e) {
      print('Decline Failed: ${e.toString()}');
    }
  }

  /// Delete Request
  Future<void> deleteRequest(String userId) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq('user_id', userId);
      requests.removeWhere((req) => req.userId == userId);
      print('Request Deleted Successfully');
      notifyListeners();
    } catch (e) {
      print('Delete Failed: ${e.toString()}');
    }
  }
}
