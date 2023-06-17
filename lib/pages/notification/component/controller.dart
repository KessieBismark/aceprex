import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class NotificationController extends GetxController {
  List<NotifyModel> notify = <NotifyModel>[];
  List<NotifyModel> notifyList = <NotifyModel>[];
  final searchController = TextEditingController();
  final isSearching = false.obs;

  var loadData = false.obs;
  var getUnread = false.obs;
  List<int> readIDS = [];
  int month = 0;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    getData();
    getMessageCount();
    startTimer();
  }

  void startTimer() {
    // Fetch messages every 2 seconds
    timer = Timer.periodic(const Duration(seconds: 20), (_) {
      Utils.checkInternet().then((value) {
        if (value) {
          getData();
          getMessageCount();
        }
      });
    });
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
  getData() {
    Utils.checkInternet().then((value) {
      if (!value) {
      //  Utils().showError("There's no internet connection");
        return;
      }
    });
    loadData.value = true;
    fetchData().then((value) {
      notify = [];
      notify.addAll(value);
      notifyList = [];
      notifyList = notify;
      loadData.value = false;
    });
  }

  getMessageCount() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        // Utils().showError("There's no internet connection");
        return;
      }
    });

    try {
      var query = {
        "action": "get_unread_count",
        "userID": Utils.userID,
      };
      var response = await Query.queryData(query);
      if (jsonDecode(response) == 'false') {
      } else {
        var res = jsonDecode(response);
        Utils.messageCount.value = res[0]['count'];
      }
    } catch (e) {
      print.call(e);
      // Utils().showError(e.toString(), "Login");
    }
  }

  updateRead(int id, int index) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    try {
      var query = {
        "action": "update_read",
        "id": id.toString(),
      };
      var response = await Query.queryData(query);
      if (jsonDecode(response) == 'true') {
        if (!readIDS.contains(id)) {
          notifyList[index].status = 'read';
          readIDS.add(id);
          if (Utils.messageCount.value != 0) {
            Utils.messageCount -= 1;
          }
          loadData.value = true;
          loadData.value = false;
          loadData.value = false;
        }
      }
    } catch (e) {
      loadData.value = false;
      // ignore: avoid_print
      print(e);
    }
  }

  Future<List<NotifyModel>> fetchData() async {
    var permission = <NotifyModel>[];
    try {
      var data = {"action": "get_notification", "userID": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(NotifyModel.fromJson(empJson));
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
