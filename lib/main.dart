import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'services/isolate_services/notification.dart';
import 'services/utils/helpers.dart';
import 'services/utils/notify.dart';
import 'services/utils/query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'services/config/binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'services/config/routes.dart';
import 'services/utils/themes.dart';

const fetchBackground = "backgroundTask";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  // Workmanager().registerPeriodicTask(
  //   'backgroundTask',
  //   'backgroundTask',
  //   constraints: Constraints(
  //       networkType: NetworkType.connected,
  //       requiresBatteryNotLow: true,
  //       requiresDeviceIdle: true,
  //       requiresStorageNotLow: true),

  //   frequency: const Duration(milliseconds: 900000), // Run task every 24 hours
  // );

   Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
   Workmanager().registerPeriodicTask(
    "1",
    fetchBackground,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
        networkType: NetworkType.connected,
        requiresDeviceIdle: false,
        requiresCharging: false,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false),
  );

  sqfliteFfiInit();
  await NotificationService.initializeNotification();

  await Permission.storage.isDenied.then((value) {
    if (value) {
      Permission.storage.request();
    }
  });

  await GetStorage.init();
  AwesomeNotifications().resetGlobalBadge();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifecycleObserver lifecycleObserver;
  @override
  void initState() {
    super.initState();
    lifecycleObserver = AppLifecycleObserver(
      onAppForeground: () {
        setOnline('1');
      },
      onAppBackground: () {
        setOnline('0');
      },
    );
  }

  setOnline(String status) async {
    if (status == '0') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("chatMeg", Utils.notifyMeg.join(','));
    }
    Utils.checkInternet().then((value) async {
      if (value) {
        try {
          var query = {
            "action": "set_online",
            "status": status,
            "userID": Utils.userID,
          };
          var response = await Query.queryData(query);
          if (jsonDecode(response) == 'false') {
            // Handle error case
          } else {
            // Handle success case
          }
        } catch (e) {
          print.call(e);
          // Handle error case
        }
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllBindings(),
      title: 'AcePrex',
      theme: Themes().lightTheme,
      getPages: Routes.routes,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      initialRoute: '/splash',
      defaultTransition: Transition.fadeIn,
    );
  }
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userID = '';
        List<String> chatMeg = [];
        if (prefs.containsKey("userID")) {
          userID = prefs.getString("userID")!;
          if (prefs.containsKey('chatMeg')) {
            chatMeg = prefs.getString("chatMeg")!.split(',');
          }
          try {
            var data = {"action": "push_notification", "userID": userID};
            var response = await Query.queryData(data);
            if (jsonDecode(response) != 'false') {
              List<dynamic> jsonData = jsonDecode(response);
              for (var entry in jsonData) {
                final date = entry['created_at'];
                // final id = entry['chatID'];
                final senderName = entry['senderName'];
                final message = entry['message'];
                final avatar = entry['message'] ?? '';
                final isOnline = entry['message'];
                final senderID = entry['senderID'].toString();
                // Display notification
                if (!chatMeg.contains('$message$date')) {
                  if (userID != senderID) {
                    NotificationService.showNotification(
                        id: createUniqueId(),
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
                  }
                }
                chatMeg.add('$message$date');
                prefs.setString("chatMeg", chatMeg.join(','));
              }
            }
          } catch (e) {
            print.call(e);
          }
        }
        break;
    }
    return Future.value(true);
  });
}

class AppLifecycleObserver with WidgetsBindingObserver {
  final Function onAppForeground;
  final Function onAppBackground;

  AppLifecycleObserver({
    required this.onAppForeground,
    required this.onAppBackground,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppForeground();
    } else if (state == AppLifecycleState.paused) {
      onAppBackground();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
