import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  var loading = false.obs;
  var showPassword = false.obs;

//   Future<InternetAddress> get selfIP async {
//     String ip = await Wifi.ip;
//     return InternetAddress(ip);
// }

  // Future getIP() async {
  //   return await info.getWifiIP();
  // }

  login() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
         loading.value = false ;
        return;
      }
    });

    if (formKey.currentState!.validate()) {
      loading.value = true;
      try {
        var query = {
          "action": "login",
          "email": email.text,
          "password": pass.text
        };
        var response = await Query.queryData(query);
        if (jsonDecode(response) == 'false') {
          Utils().showError('Wrong Login credentials');
          loading.value = false;
        } else {
          var res = jsonDecode(response);
          Utils.userID = res[0]['id'].toString();
          Utils.userName = res[0]['name'];
          Utils.userRole = res[0]['role'];
          Utils.userEmail = res[0]['email'];
          Utils.userAvatar.value = res[0]['avatar'];
          Utils.setLogin(
              userID: Utils.userID,
              userName: Utils.userName,
              userEmail: Utils.userEmail,
              userRole: Utils.userRole,
              userAvatar: Utils.userAvatar.value);
          loading.value = false;
          Get.offAllNamed('/dash');
        }
      } catch (e) {
        loading.value = false;
        print.call(e);
        // Utils().showError(e.toString(), "Login");
      }
    }
  }
}
