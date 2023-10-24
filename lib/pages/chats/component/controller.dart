import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/model.dart';
import 'package:http/http.dart' as http;
import '../../../services/isolate_services/notification.dart';

import '../../../services/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class ChatUIController extends GetxController {
  List<ChatList> chatList = <ChatList>[];
  List<ChatList> chatListData = <ChatList>[];
  List<ChatModel> chats = <ChatModel>[];
  List<ChatMessage> chatPerson = <ChatMessage>[];
  var chatLoad = false.obs;
  List<PeopleModel> people = <PeopleModel>[];
  List<PeopleModel> peopleList = <PeopleModel>[];
  final searchController = TextEditingController();
  final isSearching = false.obs;
  var peopleLoad = false.obs;
  final db = DatabaseHelper.instance;

  var getUnread = false.obs;

  // var chatChanges = ''.obs;
  List<ChatList> sortedList = [];
  ScrollController scrollController = ScrollController();
  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    getChats();
    getPeople();
    getUnreadChats();
    startTimer(); // Start the timer
  }

  void startTimer() {
    // Fetch messages every 2 seconds

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      Utils.checkInternet().then((value) {
        if (value) {
          getChats();
          getUnreadChats();
        }
      });
    });
  }

  getUnreadChats() async {
    try {
      var query = {
        "action": "get_Uread_Count",
        "userID": Utils.userID,
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'false') {
      } else {
        var data = jsonDecode(result);
        Utils.unReadChat.value = data[0]['count'];
      }
    } catch (e) {
      print.call(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }

  Map<int, String> weekdayLabels = {
    DateTime.monday: "Mon",
    DateTime.tuesday: "Tue",
    DateTime.wednesday: "Wed",
    DateTime.thursday: "Thu",
    DateTime.friday: "Fri",
    DateTime.saturday: "Sat",
    DateTime.sunday: "Sun",
  };

// chatlist codes---------------------------------------------------------------
  Future<void> saveChats() async {
    fetchchatMessages().then((value) {
      // final chatMessages = await fetchchatMessages();
      chatListData.clear();
      chatList.clear();
      chatList.addAll(value);
      for (int i = 0; i < chatList.length; i++) {
        if (chatList[i].lastMessageSeen == 0 &&
            !Utils.notifyMeg.contains(
                ('${chatList[i].lastMessage}${chatList[i].lastDate}'))) {
          if (Utils.userID != chatList[i].fromID.toString()) {
            NotificationService.showNotification(
                id: chatList[i].chatID,
                title: chatList[i].name,
                body: chatList[i].lastMessage!.isEmpty
                    ? 'image file'
                    : chatList[i].lastMessage!,
                channelKey: 'chat',
                payload: ({
                  "type": "chat",
                  "avatar": chatList[i].fromImage!,
                  "name": chatList[i].name,
                  "to": chatList[i].fromID.toString(),
                  "isOnline": chatList[i].isOnline.toString()
                }));
          }
          Utils.notifyMeg
              .add('${chatList[i].lastMessage}${chatList[i].lastDate}');
        }
      }
      chatListData = chatList;
      chatLoad.value = true;
      chatLoad.value = false;
    });
  }

  // Future<void> saveHeadChats() async {
  //   fetchchatMessages().then((value) {
  //     chatListData.clear();
  //     chatList.clear();
  //     chatList.addAll(value);

  //     for (int i = 0; i < chatList.length; i++) {
  //       if (chatList[i].fromID == int.parse(Utils.userID)) {
  //         db.insertOrUpdateUser(User(
  //             username: chatList[i].name,
  //             id: chatList[i].toID,
  //             picture: chatList[i].fromImage));
  //         print(chatList[i].name);
  //       } else {
  //         db.insertOrUpdateUser(User(
  //             username: chatList[i].name,
  //             id: chatList[i].fromID,
  //             picture: chatList[i].fromImage));
  //         print(chatList[i].name);
  //       }
  //     }

  //     chatListData = chatList;
  //     chatLoad.value = true;
  //     chatLoad.value = false;
  //   });
  // }



  Future<void> getChats() async {
    fetchchatMessages().then((value) {
      // final chatMessages = await fetchchatMessages();
      chatListData.clear();
      chatList.clear();

      chatList.addAll(value);

      for (int i = 0; i < chatList.length; i++) {
        if (chatList[i].lastMessageSeen == 0 &&
            !Utils.notifyMeg.contains(
                ('${chatList[i].lastMessage}${chatList[i].lastDate}'))) {
          if (Utils.userID != chatList[i].fromID.toString()) {
            NotificationService.showNotification(
                id: chatList[i].chatID,
                title: chatList[i].name,
                body: chatList[i].lastMessage!.isEmpty
                    ? 'image file'
                    : chatList[i].lastMessage!,
                channelKey: 'chat',
                payload: ({
                  "type": "chat",
                  "avatar": chatList[i].fromImage!,
                  "name": chatList[i].name,
                  "to": chatList[i].fromID.toString(),
                  "isOnline": chatList[i].isOnline.toString()
                }));
          }
          Utils.notifyMeg
              .add('${chatList[i].lastMessage}${chatList[i].lastDate}');
        }
      }
      chatListData = chatList;
      chatLoad.value = true;
      chatLoad.value = false;
    });
  }

  Future<List<ChatList>> fetchchatMessages() async {
    var permission = <ChatList>[];
    try {
      var data = {"action": "get_chat2", "userID": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(ChatList.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  getPeople() {
    peopleLoad.value = true;
    fetchPeople().then((value) {
      people.clear();
      peopleList.clear();
      people.addAll(value);
      peopleList = people;
      peopleLoad.value = false;
    });
  }

  Future<List<PeopleModel>> fetchPeople() async {
    var permission = <PeopleModel>[];
    try {
      var data = {"action": "get_people", "from": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(PeopleModel.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  // Future<void> saveLocalChats() async {
  //   List<User> users = <User>[];
  //   users = await db.getUsers();
  //   Uint8List? attach;
  //   for (int i = 0; i < users.length; i++) {
  //     chatPerson.clear();
  //     fetchChatPerson(users[i].id!).then((value) async {
  //       chatPerson.addAll(value);
  //       for (int j = 0; j < chatPerson.length; j++) {
  //         attach = await fetchImageAsUint8List(chatPerson[i].attachment!);
  //         print(chatPerson[i].message);
  //         db.insertChatMessage(
  //           LocalChatMessage(
  //               senderId: chatPerson[i].from,
  //               receiverId: chatPerson[i].to,
  //               timestamp: chatPerson[i].date,
  //               text: chatPerson[i].message,
  //               attachmentBytes: attach),
  //         );
  //       }
  //     });
  //   }
  // }

  Future<List<ChatMessage>> fetchChatPerson(int person) async {
    var permission = <ChatMessage>[];
    try {
      var data = {
        "action": "get_chat_person",
        "person": person.toString(),
        "from": Utils.userID
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

  // Future<Uint8List?> fetchImageAsUint8List(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));

  //   if (response.statusCode == 200) {
  //     // Convert the response body (image data) to Uint8List
  //     Uint8List uint8List = Uint8List.fromList(response.bodyBytes);
  //     return uint8List;
  //   } else {
  //     // Handle the error or return null in case of failure
  //     throw Exception('Failed to load image: $imageUrl');
  //   }
  // }
}
