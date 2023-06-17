import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  // late AppLifecycleObserver lifecycleObserver;
  // bool isOnline = false;
  // Timer? backgroundTimer;

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
    update();
  }

  // Future<void> setOnline(int status) async {
  //   try {
  //     var query = {
  //       "action": "set_online",
  //       "status": status.toString(),
  //       "userID": Utils.userID,
  //     };
  //     print(query);
  //     var response = await Query.queryData(query);
  //     print(response);
  //     if (jsonDecode(response) == 'false') {
  //       // Handle error case
  //     } else {
  //       // Handle success case
  //       isOnline = (status == 1);
  //     }
  //   } catch (e) {
  //     print(e);
  //     // Handle error case
  //   }
  // }

  // void startBackgroundTimer() {
  //   cancelBackgroundTimer();
  //   backgroundTimer = Timer(const Duration(minutes: 5), () {
  //     if (isOnline) {
  //       setOnline(0);
  //     }
  //   });
  // }

  // void cancelBackgroundTimer() {
  //   backgroundTimer?.cancel();
  // }

  @override
  void onClose() {
    // setOnline(0);
    // cancelBackgroundTimer();
    // lifecycleObserver.dispose();
    super.onClose();
  }
}

// class AppLifecycleObserver with WidgetsBindingObserver {
//   final Function onAppForeground;
//   final Function onAppBackground;

//   AppLifecycleObserver({
//     required this.onAppForeground,
//     required this.onAppBackground,
//   }) {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       onAppForeground();
//     } else if (state == AppLifecycleState.paused) {
//       onAppBackground();
//     }
//   }

//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//   }
// }
