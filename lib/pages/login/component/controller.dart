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
  final verify = TextEditingController();
  final cpassword = TextEditingController();
  final resetCode = TextEditingController();
  var isSaveReset = false.obs;
  var isSendEmail = false.obs;
  final resetKey = GlobalKey<FormState>();
  var ready = false.obs;
//   Future<InternetAddress> get selfIP async {
//     String ip = await Wifi.ip;
//     return InternetAddress(ip);
// }

  // Future getIP() async {
  //   return await info.getWifiIP();
  // }

  clearData() {
    pass.clear();
    verify.clear();
    cpassword.clear();
    resetCode.clear();
    ready.value = false;
  }

  sendReset() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        loading.value = false;
        return;
      }
    });
    if (email.text.isEmpty) {
      Utils().showError("Please enter your email!");
    } else {
      try {
        isSendEmail.value = true;
        var query = {"action": "send_code", "email": email.text};
        var res = await Query.queryData(query);
        if (jsonDecode(res) == 'true') {
          Utils().showInfo("Check Your Email for a Reset Code.");
          ready.value = true;
        } else if (jsonDecode(res) == 'false') {
          Utils().showError("Email was not found!");
          ready.value = false;
        } else if (jsonDecode(res) == 'no match') {
          Utils().showError('Email was not found');
        } else {
          Utils().showError("Something went wrong! Please Try Again Later..");
          ready.value = false;
        }
        isSendEmail.value = false;
      } catch (e) {
        ready.value = false;
        isSendEmail.value = false;
        print.call(e);
        // Utils().showError(e.toString(), "Login");
      }
    }
  }

  resetPassword() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    if (resetKey.currentState!.validate()) {
      if (pass.text == cpassword.text) {
        isSaveReset.value = true;
        try {
          var query = {
            "action": "reset_password",
            "email": email.text,
            "password": pass.text,
            "code": resetCode.text
          };
          var response = await Query.queryData(query);
          if (jsonDecode(response) == 'false') {
            Utils().showError('Something went wrong. Try again later');
            isSaveReset.value = false;
          } else if (jsonDecode(response) == 'no match') {
            Utils().showError('Email was not found');
          } else if (jsonDecode(response) == 'true') {
            isSaveReset.value = false;
            Get.offAllNamed('/auth');
          } else {
            Utils().showError('Something went wrong. Try again later');
            isSaveReset.value = false;
          }
        } catch (e) {
          isSaveReset.value = false;
          print.call(e);
          // Utils().showError(e.toString(), "Login");
        }
      } else {
        Utils().showError("Password do not match!");
      }
    }
  }

  login() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        loading.value = false;
        return;
      }
    });

    if (formKey.currentState!.validate()) {
      loading.value = true;
      try {
        var query = {
          "action": "login",
          "email": email.text.trim(),
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
          Utils.userAvatar.value = 'users-avatar/${res[0]['avatar']}';
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
