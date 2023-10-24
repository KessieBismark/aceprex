import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        Get.defaultDialog(
            title: 'Allow Notifications',
            content:
                const Text('This app would like to send you notifications'),
            confirm: MTextButton(
              onTap: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => Get.back()),
              title: 'Allow',
              color: Colors.teal,
            ),
            cancel: MTextButton(
              onTap: () => Get.back(),
              title: 'Don\'t Allow',
              color: grey,
            ));
      }
    });
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
    // update();
  }
}
