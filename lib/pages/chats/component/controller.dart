import 'dart:async';
import 'dart:convert';
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

  Future<void> getChats() async {
    fetchchatMessages().then((value) {
      // final chatMessages = await fetchchatMessages();
      chatListData.clear();
      chatList.clear();
      // chatList = chatMessages;
      // for (int i = 0; i < chatMessages.length; i++) {
      //   chatList.add(ChatList(
      //     id: chatMessages[i].id,
      //     name: chatMessages[i].name,
      //     isOnline: chatMessages[i].isOnline,
      //     fromImage: chatMessages[i].fromImage,
      //     lastMessageSeen: chatMessages[i].lastMessageSeen,
      //     lastMessage: chatMessages[i].lastMessage,
      //     lastDate: chatMessages[i].lastDate,
      //   ));
      // }
      chatList.addAll(value);

      for (int i = 0; i < chatList.length; i++) {
        if (chatList[i].lastMessageSeen == 0 &&
            !Utils.notifyMeg.contains(
                ('${chatList[i].lastMessage}${chatList[i].lastDate}'))) {
          Utils.sendNotification(
              title: chatList[i].name,
              channelKey: 'chat',
              body: chatList[i].lastMessage!);
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
}
