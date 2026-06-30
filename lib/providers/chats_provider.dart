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

  List<Chats> sortedChats() {
    chats.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );
    return chats;
  }

  List<Chats> returnMainChats({
    required int index,
    required String id,
  }) {
    if (index == 3) {
      return getProjectChats(projectId: id);
    } else if (index == 2) {
      return getBranchChats(branchId: id);
    } else {
      return getPersonalChats(id: id);
    }
  }

  List<Chats> getProjectChats({required String projectId}) {
    return sortedChats()
        .where((chat) => chat.projectId == projectId)
        .toList();
  }

  List<Chats> getBranchChats({required String branchId}) {
    return sortedChats()
        .where((chat) => chat.branchId == branchId)
        .toList();
  }

  List<Chats> getPersonalChats({required String id}) {
    return sortedChats()
        .where((chat) => chat.chatId == id)
        .toList();
  }

  /// Create chat
  Future<Chats?> createChat(Chats chat) async {
    try {
      chats.add(chat);
      notifyListeners();
      var res = await _client
          .from(_table)
          .insert(chat.toJson())
          .select()
          .maybeSingle();
      if (res != null) {
        print('Chat Created Successfully');
      } else {
        chats.remove(chat);
        notifyListeners();
      }
      return chat;
    } catch (e) {
      print('Failed: ${e.toString()}');
      return null;
    }
  }

  //
  //
  Future<Chats?> updateChat(Chats chat) async {
    try {
      var index = chats.indexWhere(
        (chatt) => chatt.uuid == chat.uuid,
      );
      chats.removeWhere((chatt) => chatt.uuid == chat.uuid);
      chats.insert(index, chat);
      notifyListeners();
      await _client
          .from(_table)
          .upsert(chat.toJson())
          .select()
          .maybeSingle();
      print('Chat Updated Successfully');
      return chat;
    } catch (e) {
      print('Failed: ${e.toString()}');
      return null;
    }
  }

  //
  //

  /// Get all chats for a company
  Future<List<Chats>> getChatsByCompany(
    // int companyId,
  ) async {
    try {
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
      print(
        'All Chats Gotten Success: ${tempChats.length}',
      );
      return chats;
    } catch (e) {
      print('Error Getting All Chats: ${e.toString()}');
      return [];
    }
  }

  bool _running = false;

  Future<void> startRepeatingFunction({
    required id,
    required int chatType,
  }) async {
    _running = true;

    while (_running) {
      await getChatsByGroup(id: id, chatType: chatType);
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void stopRepeatingFunction() {
    _running = false;
  }

  //
  //
  //
  //
  Future<List<Chats>> getChatsByGroup({
    required String id,
    required int chatType,
  }) async {
    try {
      String chatIdTemp = chatType == 1
          ? 'chat_id'
          : chatType == 2
          ? 'branch_id'
          : 'project_id';
      final response = await _client
          .from(_table)
          .select()
          .eq(chatIdTemp, id);

      List<Chats> tempChats = (response as List)
          .map((json) => Chats.fromJson(json))
          .toList();
      chats.removeWhere(
        (chat) =>
            chat.chatId == id ||
            chat.branchId == id ||
            chat.projectId == id,
      );
      // chats.clear();

      chats.addAll(tempChats);
      notifyListeners();
      print(
        'Group Chats Gotten Success: ${tempChats.length}',
      );
      return chats;
    } catch (e) {
      print('Error Getting Group Chats: ${e.toString()}');
      return [];
    }
  }

  /// Delete chat
  Future<void> deleteChat(String uuid) async {
    try {
      chats.removeWhere((chat) => chat.uuid == uuid);
      notifyListeners();
      await _client.from(_table).delete().eq('uuid', uuid);

      print('Chat Delete Successfully');
      // await getChatsByCompany();
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
