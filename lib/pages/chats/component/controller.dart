import 'dart:async';
import 'dart:convert';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/model.dart';
import 'package:aceprex/services/database/receive.dart';
import 'package:aceprex/services/database/send.dart';
import 'package:aceprex/services/isolate_services/notification.dart';

import '../../../services/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class ChatUIController extends GetxController {
  List<LocalChatMessage> chatList = <LocalChatMessage>[];
  List<LocalChatMessage> chatListData = <LocalChatMessage>[].obs;
  List<ChatHead> chatHead = <ChatHead>[];
  List<ChatHead> chatHeadData = <ChatHead>[].obs;

  List<ChatList> onlineChatList = <ChatList>[];

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

  List<ChatList> sortedList = [];
  ScrollController scrollController = ScrollController();
  Timer? timer;
  Timer? hTimer;
  @override
  void onInit() {
    super.onInit();
    saveHeadChats();
    getChatHead();
    getPeople();
    startTimer(); // Start the timer
    headTimer();
  }

  void startTimer() {
    // Fetch messages every 2 seconds
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      getChatHead();
      Utils.checkInternet().then((value) async {
        if (value) {
          //saveHeadChats();
          saveChats();
        }
      });
    });
  }

  void headTimer() {
    // Fetch messages every 2 seconds
    hTimer?.cancel();
    hTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      Utils.checkInternet().then((value) async {
        if (value) {
          saveHeadChats();
          await SendChat().synchronizeChatMessages();
        }
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
    hTimer?.cancel();
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

  Future<void> saveHeadChats() async {
    String? ids = await db.getGroupConcatForUserId();
    fetchchatMessages(ids).then((value) async {
      onlineChatList.clear();
      onlineChatList.addAll(value);
      for (int i = 0; i < onlineChatList.length; i++) {
        await db.insertOrUpdateUser(User(
            username: onlineChatList[i].name,
            id: onlineChatList[i].id,
            online: onlineChatList[i].isOnline,
            profilePicture: onlineChatList[i].fromImage));
      }
      onlineChatList.clear();
    });
    saveChats();
    List<Online> statisticList = [];
    fetchStatis(ids).then((value) async {
      statisticList.clear();
      statisticList.addAll(value);
      for (int i = 0; i < onlineChatList.length; i++) {
        await SendChat()
            .onLineStatus(onlineChatList[i].isOnline, onlineChatList[i].id);
      }
      statisticList.clear();
    });
  }

  Future<void> saveChats() async {
    int id = await db.getMaxId();
    List<ChatMessage> list = [];
    await ReceiveChat().getMyChatList(id).then((value) async {
      list.addAll(value);
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          if (Utils.userID == list[i].to.toString()) {
            await SendChat().insertChatMessage(LocalChatMessage(
                receiverId: list[i].to,
                senderId: list[i].from,
                text: list[i].message,
                attachment: list[i].attachment,
                seen: list[i].seen,
                timestamp: list[i].date,
                sync: 1,
                userID: int.parse("${Utils.userID}${list[i].from}"),
                id: list[i].id));
          } else {
            await SendChat().insertChatMessage(LocalChatMessage(
                receiverId: list[i].to,
                senderId: list[i].from,
                text: list[i].message,
                attachment: list[i].attachment,
                seen: list[i].seen,
                sync: 1,
                timestamp: list[i].date,
                userID: int.parse("${Utils.userID}${list[i].to}"),
                id: list[i].id));
          }
          if (Utils.userID != list[i].from.toString()) {
            NotificationService.showNotification(
                id: list[i].id,
                title: list[i].name!,
                groupKey: "${Utils.userID}${list[i].to}",
                body:
                    list[i].message!.isEmpty ? 'Image File' : list[i].message!,
                channelKey: 'chat',
                payload: ({
                  "type": "chat",
                  "name": list[i].name!,
                  "to": list[i].from.toString(),
                  "isOnline": list[i].isOnline.toString()
                }));
          }
        }
      }
    });
  }

  Future<void> getChatHead() async {
    try {
      chatHead.clear();
      List<User> users = await db.getUsers();
      for (int i = 0; i < users.length; i++) {
        LocalChatMessage? chat = await db.getMostRecentChatMessage(
            int.parse("${Utils.userID}${users[i].id}"));
        if (chat != null) {
          int unRead = await db
              .countUnseenMessages(int.parse("${Utils.userID}${users[i].id}"));
          chatHead.add(ChatHead(
              id: users[i].id!,
              name: users[i].username,
              profile: users[i].profilePicture!,
              isOnline: users[i].online,
              from: chat.senderId,
              to: chat.receiverId,
              attachment: chat.attachment,
              lastMessage: chat.text,
              unSeenCount: unRead,
              timeStamp: chat.timestamp,
              seen: chat.seen));
        }
      }
      chatHeadData.clear();
      chatHead.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      chatHeadData.addAll(chatHead);
    } catch (e) {
      print.call(e.toString());
    }
  }

  Future<List<ChatList>> fetchchatMessages(String? list) async {
    var permission = <ChatList>[];
    try {
      var data = {"action": "get_chat2", "userID": Utils.userID, "list": list};
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

  Future<List<Online>> fetchStatis(String? list) async {
    var permission = <Online>[];
    try {
      var data = {"action": "get_online_status", "list": list};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(Online.fromJson(empJson));
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
}
