import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/utils/helpers.dart';
import '../../services/utils/query.dart';

class SController extends GetxController {
  final signUpKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final cPass = TextEditingController();

  final email = TextEditingController();
  final username = TextEditingController();
  var loading = false.obs;

  signUP() async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    if (signUpKey.currentState!.validate()) {
      if (pass.text == cPass.text) {
        loading.value = true;
        try {
          var query = {
            "action": "signup",
            "email": email.text,
            "name": username.text,
            "password": pass.text
          };
          var response = await Query.queryData(query);
          if (jsonDecode(response) == 'false') {
            Utils().showError('Something went wrong. Try again later');
            loading.value = false;
          } else {
            // var res = jsonDecode(response);
            // Utils.userID = res[0]['id'].toString();
            // Utils.userName = res[0]['name'];
            // Utils.userRole = res[0]['role'];
            // Utils.userEmail = res[0]['email'];
            // Utils.setLogin(
            //   userID: Utils.userID,
            //   userName: Utils.userName,
            //   userEmail: Utils.userEmail,
            //   userRole: Utils.userRole,
            // );
            loading.value = false;
            Get.offAllNamed('/auth');
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          // Utils().showError(e.toString(), "Login");
        }
      } else {
        Utils().showError("Password do not match!");
      }
    }
  }
}
