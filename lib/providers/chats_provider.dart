import 'package:flutter/material.dart';
import 'package:promas/classes/chats.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsProvider extends ChangeNotifier {
  static final ChatsProvider _instance =
      ChatsProvider._internal();
  factory ChatsProvider() => _instance;
  ChatsProvider._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'chats';

  List<Chats> chats = [];

  void clearCache() {
    chats.clear();
    notifyListeners();
  }

  List<Chats> getProjectChats({required String projectId}) {
    return chats
        .where((chat) => chat.projectId == projectId)
        .toList();
  }

  List<Chats> getBranchChats({required String branchId}) {
    return chats
        .where((chat) => chat.branchId == branchId)
        .toList();
  }

  List<Chats> getPersonalChats({
    required String chatchatId,
  }) {
    return chats
        .where((chat) => chat.chatId == chatchatId)
        .toList();
  }

  /// Create chat
  Future<Chats?> createChat(Chats chat) async {
    try {
      _client
          .from(_table)
          .insert(chat.toJson())
          .select()
          .single();
      print('Chat Created Successfully');
      // chats.add(Chats.fromJson(response));
      chats.add(chat);
      getChatsByCompany();
      // return Chats.fromJson(response);

      notifyListeners();
      return chat;
    } catch (e) {
      print('Failed: ${e.toString()}');
      return null;
    }
  }

  /// Get all chats for a company
  Future<List<Chats>> getChatsByCompany(
    // int companyId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq(
          'company_id',
          CompanyProvider().currentCompany!.id!,
        );

    List<Chats> tempChats = (response as List)
        .map((json) => Chats.fromJson(json))
        .toList();

    chats = tempChats;
    notifyListeners();
    return chats;
  }

  /// Delete chat
  Future<void> deleteChat(String uuid) async {
    try {
      await _client.from(_table).delete().eq('uuid', uuid);
      chats.removeWhere((chat) => chat.uuid == uuid);
      notifyListeners();
      print('Chat Delete Successfully');
      await getChatsByCompany();
    } catch (e) {
      print('Delete Failed: ${e.toString()}');
    }
  }
}

// String chatId({required Chats chat}) {
//   return chat.projectId ??
//       chat.branchId ??
//       chat.chatId ??
//       '';
// }

String chatId({
  required String user1,
  required String user2,
}) {
  return '${user1}_$user2';
}
