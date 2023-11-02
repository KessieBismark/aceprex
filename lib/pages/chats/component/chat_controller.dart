import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aceprex/pages/startup/startup.dart';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/receive.dart';
import 'package:aceprex/services/database/send.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/constants/server.dart';
import '../../../services/database/model.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class ChatPlaceController extends GetxController {
  List<LocalChatMessage> chatData = <LocalChatMessage>[];
  Timer? chatTimer;
  final send = SendChat();
  var isSendMessage = false.obs;
  final messageController = TextEditingController();
  var chatBool = false.obs;
  bool chatListPull = false;
  var isSendFile = false.obs;
  var isDownload = false.obs;
  final db = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    if (Utils.userID.isEmpty) {
      Get.to(() => const StartUp());
    }
    chatData.clear();
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

  @override
  void onClose() {
    super.onClose();
    ChatPlaceController().dispose();
    chatTimer?.cancel();
  }

  void startChatTimer(int person) {
    // Fetch messages every 2 seconds
    chatTimer?.cancel();
    chatTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      getUserChat(int.parse("${Utils.userID}$person"));
      Utils.checkInternet().then((value) {
        if (value) {
          setSeen(person);
          getUpdateLocalSeen();
        }
      });
    });
  }

  getUserChat(int userID) async {
    chatData = await db.getChatMessages(userID);
    chatBool.value = true;
    chatBool.value = false;
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      isDownload.value = true;
      var response = await http.get(Uri.parse(imageUrl));
      var bytes = response.bodyBytes;

      var directory =
          await getTemporaryDirectory(); // Use getApplicationDocumentsDirectory() to save the image permanently
      var file = File('${directory.path}/image.jpg');

      await file.writeAsBytes(bytes);
      isDownload.value = false;
      // Show a success message or perform any other actions
      Utils().showInfo('Image downloaded successfully');
    } catch (e) {
      // Handle the error
      isDownload.value = false;
      Utils().showError('Error occurred while downloading image: $e');
    }
  }

  List<String> extractImageNames(String jsonStr) {
    final List<String> imageNames = [];

    try {
      final Map<String, dynamic> jsonData = json.decode(jsonStr);

      jsonData.forEach((key, value) {
        if (value is String) {
          imageNames.add(value);
        }
      });
    } catch (e) {
      // Handle invalid JSON
    }

    return imageNames;
  }

  sendMessage(
      {String? message,
      required int to,
      String? name,
      required int online,
      String? picture}) async {
    int cid = Utils.chatID();
    LocalChatMessage data = LocalChatMessage(
        id: cid,
        senderId: int.parse(Utils.userID),
        receiverId: to,
        seen: 0,
        sync: 0,
        text: message,
        timestamp: DateTime.now(),
        userID: int.parse("${Utils.userID}$to"));
    await db.insertOrUpdateUser(
        User(username: name!, id: to, online: online, profilePicture: picture));
    await SendChat().insertChatMessage(data);
    getUserChat(int.parse("${Utils.userID}$to"));
    messageController.clear();
    Utils.checkInternet().then((value) {
      if (value) {
        sendChatOnline(
            message: message,
            to: to,
            cid: cid,
            date: DateTime.now(),
            data: data);
      }
    });
  }

  sendFile({dynamic file, String? attachment, required int to}) async {
    int cid = Utils.chatID();
    LocalChatMessage data = LocalChatMessage(
        id: cid,
        senderId: int.parse(Utils.userID),
        receiverId: to,
        seen: 0,
        attachment: attachment,
        timestamp: DateTime.now(),
        userID: int.parse("${Utils.userID}$to"));
    await SendChat().insertChatMessage(data);
    getUserChat(int.parse("${Utils.userID}$to"));
    Utils.checkInternet().then((value) {
      if (value) {
        insertImage(file, to);
      }
    });
  }

  sendChatOnline(
      {String? message,
      required int to,
      required int cid,
      required DateTime date,
      required LocalChatMessage data}) async {
    try {
      var query = {
        "action": "send_chat_message",
        "cid": cid.toString(),
        "from": Utils.userID,
        "to": to.toString(),
        "message": message!.replaceAll('\n', ' '),
        'date': date.toString()
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        isSendMessage.value = false;
        await SendChat().markMessageAsSynchronized(cid);
      } else {
        Utils().showError("Sorry, something went wrong!");
        isSendMessage.value = false;
      }
    } catch (e) {
      isSendMessage.value = false;
      print.call(e);
      //  Utils().showError(e.toString(), appName);
    }
  }

  setSeen(int from) async {
    await SendChat().markAllSeenMessage(
        int.parse("${Utils.userID}$from"), int.parse(Utils.userID));
    Utils.checkInternet().then((value) {
      if (value) {
        setOnline(from);
      }
    });
  }

  setOnline(int from) async {
    try {
      var query = {
        "action": "set_chat_to_read",
        "to": Utils.userID,
        "person": from.toString()
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        getUnreadChats();
      } else {}
    } catch (e) {
      isSendMessage.value = false;
      print.call(e);
      //  Utils().showError(e.toString(), appName);
    }
  }

  void handleImageSelection(int toID) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      sendFile(file: result, attachment: result.path, to: toID);
    }
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

  insertImage(dynamic file, int toID) async {
    try {
      Utils.checkInternet().then((value) {
        if (!value) {
          Utils().showError("There's no internet connection");

          return;
        }
      });
      isSendFile.value = true;
      var request = http.MultipartRequest("POST", Uri.parse(Api.url));
      request.fields['from'] = Utils.userID;
      request.fields['to'] = toID.toString();
      request.fields['date'] = DateTime.now().toString();
      request.fields['action'] = "send_image";
      String fileName = file.name;
      List<int> fileBytes = await SendChat().compressImage(file.readAsBytes());
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          fileBytes,
          filename: fileName,
        ),
      );

      var response = await request.send();
      var reponseData = await response.stream.toBytes();
      var result = String.fromCharCodes(reponseData);

      if (jsonDecode(result) == 'true') {
        isSendFile.value = false;
        getUserChat(int.parse("${Utils.userID}$toID"));
      }
      isSendFile.value = false;
    } catch (e) {
      isSendFile.value = false;
      print.call(e);
      //  Utils().showError(e.toString(), appName);
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

  getUpdateLocalSeen() async {
    int lastID = await SendChat().getLastId();
    List<ChatMessage> list = [];
    ReceiveChat().getSeen(int.parse(Utils.userID), lastID).then((value) async {
      list.addAll(value);
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          await SendChat().markSeenMessage(list[i].id);
        }
      }
    });
  }
}
