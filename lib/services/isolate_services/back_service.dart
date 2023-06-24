import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/helpers.dart';
import '../utils/query.dart';
import 'notification.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = '';
  if (prefs.containsKey("userID")) {
    userID = prefs.getString("userID")!;
  }

  Future<void> fetchNewChatMessage() async {
    try {
      var data = {"action": "push_notification", "userID": userID};
      var response = await Query.queryData(data);
      if (jsonDecode(response) != 'false') {
        List<dynamic> jsonData = jsonDecode(response);
        for (var entry in jsonData) {
          //   final id = entry['id'];
          // final senderName =
          //     entry['senderName']; // Replace with actual sender name key
          // final message = entry['message']; // Replace with actual message key
          // final senderID = entry['senderID'];

          final id = entry['chatID'];

          final senderName = entry['senderName'];
          final message = entry['message'];
          final avatar = entry['message'] ?? '';
          final isOnline = entry['message'];
          final senderID = entry['senderID'].toString();
          // Display notification
          NotificationService.showNotification(
              id: id,
              title: senderName,
              body: message,
              channelKey: 'chat',
              groupKey: senderID,
              payload: ({
                "type": "chat",
                "avatar": avatar,
                "name": senderName,
                "to": senderID.toString(),
                "isOnline": isOnline.toString()
              }));
          // Utils.sendNotification(
          //     channelKey: 'chat',
          //     title: senderName,
          //     body: message,
          //     groupKey: senderID);
        }
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      var data = {"action": "get_unread_notifications", "userID": userID};
      var response = await Query.queryData(data);
      if (jsonDecode(response) != 'false') {
        List<dynamic> jsonData = jsonDecode(response);
        for (var entry in jsonData) {
          final id = entry['id'];
          final title = entry['title']; // Replace with actual sender name key
          final message = entry['message']; // Replace with actual message key
          final senderID = entry['senderID'];
          // Display notification
          NotificationService.showNotification(
              id: id,
              title: title,
              body: message,
              channelKey: 'notification',
              groupKey: senderID,
              payload: ({"type": "notification"}));

          // Utils.sendNotification(
          //     channelKey: 'notification',
          //     title: title,
          //     body: message,
          //     groupKey: senderID);
        }
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    Utils.checkInternet().then((value) async {
      if (value) {
        await fetchNewChatMessage();
        await fetchNotifications();
      }
    });
  });
  service.invoke('update');
}

// // Future<void> initializeNotifications() async {
// //   const AndroidInitializationSettings initializationSettingsAndroid =
// //       AndroidInitializationSettings('ic_launcher');

// //   const InitializationSettings initializationSettings =
// //       InitializationSettings(android: initializationSettingsAndroid);

// //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// // }

// class BackgroundService {
//   static Future<bool> onIosBackground(ServiceInstance service) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     DartPluginRegistrant.ensureInitialized();
//     return true;
//   }

//   static Future<void> onStart(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });
//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userID = '';
//     if (prefs.containsKey("userID")) {
//       userID = prefs.getString("userID")!;
//     }

//     Future<void> fetchNewChatMessage() async {
//       try {
//         var data = {"action": "push_notification", "userID": userID};

//         var response = await Query.queryData(data);
//         print(response);

//         if (jsonDecode(response) != 'false') {
//           List<dynamic> jsonData = jsonDecode(response);

//           for (var entry in jsonData) {
//             final senderName =
//                 entry['senderName']; // Replace with actual sender name key
//             final message = entry['message']; // Replace with actual message key
//             final senderID = entry['senderID'];
//             // Display notification
//             Utils.sendNotification(
//                 channelKey: 'chat',
//                 title: senderName,
//                 body: message,
//                 groupKey: senderID);
//           }
//         }
//       } catch (e) {
//         print(e);
//         return;
//       }
//     }

//     Future<void> fetchNotifications() async {
//       try {
//         var data = {"action": "get_unread_notifications", "userID": userID};

//         var response = await Query.queryData(data);
//         if (jsonDecode(response) != 'false') {
//           List<dynamic> jsonData = jsonDecode(response);

//           for (var entry in jsonData) {
//             final title = entry['title']; // Replace with actual sender name key
//             final message = entry['message']; // Replace with actual message key
//             final senderID = entry['senderID'];
//             // Display notification
//             Utils.sendNotification(
//                 channelKey: 'notification',
//                 title: title,
//                 body: message,
//                 groupKey: senderID);
//           }
//         }
//       } catch (e) {
//         print(e);
//         return;
//       }
//     }

//     Timer.periodic(const Duration(seconds: 30), (timer) async {
//       Utils.checkInternet().then((value) async {
//         if (value) {
//           await fetchNewChatMessage();
//           await fetchNotifications();
//         }
//       });
//     });

//     service.invoke('update');
//   }

//   static Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: true,
//         autoStart: true,
//       ),
//     );
//   }
// }
