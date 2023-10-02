import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aceprex/pages/startup/startup.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/constants/server.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class ChatPlaceController extends GetxController {
  List<ChatMessage> chatData = <ChatMessage>[];
  Timer? chatTimer;
  var isSendMessage = false.obs;
  final messageController = TextEditingController();
  var chatBool = false.obs;
  bool chatDataPull = false;
  bool chatListPull = false;
  var isSendFile = false.obs;
  var isDownload = false.obs;

  //var chatLength = 0.obs;

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
    chatTimer?.cancel();
  }

  void startChatTimer(int person) {
    // Fetch messages every 2 seconds
    chatTimer?.cancel();
    chatTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      Utils.checkInternet().then((value) {
        if (value) {
          if (!chatDataPull && !chatDataPull) {
            getUserChat(person);
          }
        }
      });
    });
  }

  getUserChat(int person) {
    fetchChatPerson(person).then((value) {
      chatData.clear();
      if (value.isNotEmpty) {
        chatData.addAll(value);
        // chatData.sort((a, b) => b.date.compareTo(a.date));
        // if (chatData.isNotEmpty) {
        //   chatChanges.value = chatData.join(',');
        // } else {
        //   chatData.clear();
        // }
        // chatLength.value = chatData.length;
        chatBool.value = true;
        chatBool.value = false;
        setSeen(person);
      }

      chatDataPull = false;
    });
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

  sendMessage(String message, int to) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    try {
      isSendMessage.value = true;
      var query = {
        "action": "send_chat_message",
        "from": Utils.userID,
        "to": to.toString(),
        "message": message.replaceAll('\n', ' '),
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        isSendMessage.value = false;
        getUserChat(to);
        messageController.clear();
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
    Utils.checkInternet().then((value) {
      if (!value) {
        // Utils().showError("There's no internet connection");
        return;
      }
    });
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
      insertImage(result, toID);
      // final bytes = await result.readAsBytes();
      // final image = await decodeImageFromList(bytes);
    }
  }

  getUnreadChats() async {
    // Utils.checkInternet().then((value) {
    //   if (!value) {
    //     Utils().showError("There's no internet connection");
    //     return;
    //   }
    // });
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
      request.fields['action'] = "send_image";
      String fileName = file.name;
      List<int> fileBytes = await file.readAsBytes();
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
        getUserChat(toID);
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
      chatListPull = false;
      print.call(e);
      return permission;
    }
  }
}
