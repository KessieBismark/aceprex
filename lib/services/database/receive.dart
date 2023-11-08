import 'dart:convert';
import 'package:aceprex/pages/chats/component/model.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:aceprex/services/utils/query.dart';

class ReceiveChat {
  getNewChats(int lastID) {
    getMyChatList(lastID).then((value) {
      return value;
    });
  }

  Future<List<ChatMessage>> getMyChatList(int id) async {
    var permission = <ChatMessage>[];
    try {
      var data = {
        "action": "get_chat_data",
        "id": id.toString(),
        "userID": Utils.userID
      };

      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(ChatMessage.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print.call(e);
      return permission;
    }
  }

  Future<List<ChatMessage>> getSeen(int from, int lastID) async {
    var permission = <ChatMessage>[];
    try {
      var data = {
        "action": "get_seen",
        "from": Utils.userID,
        "id": lastID.toString()
      };

      var result = await Query.queryData(data);

      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(ChatMessage.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print.call(e);
      return permission;
    }
  }
}
