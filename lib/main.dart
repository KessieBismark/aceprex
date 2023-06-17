import 'dart:convert';
import 'dart:io';

import 'package:aceprex/pages/chats/chat_list.dart';
import 'package:aceprex/pages/library/library.dart';
import 'package:aceprex/pages/notification/notifications.dart';
import 'package:aceprex/services/isolate_services/back_service.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:aceprex/services/utils/query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/config/binding.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'services/config/routes.dart';
import 'services/utils/themes.dart';

void main() async {
  sqfliteFfiInit();

  AwesomeNotifications().initialize(
    'resource://drawable/res_logo',
    [
      NotificationChannel(
          channelKey: 'chat',
          channelName: 'Basic Notification',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: 'aceprex'),
      NotificationChannel(
          channelKey: 'notification',
          channelName: 'Basic Notification',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: 'aceprex'),
      NotificationChannel(
          channelKey: 'library',
          channelName: 'Basic Notification',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: 'aceprex')
    ],
  );
  ReceivedAction? receivedAction = await AwesomeNotifications()
      .getInitialNotificationAction(removeFromActionEvents: false);
  if (receivedAction?.channelKey == 'chat') {
    Get.to(() => const ChatList());
  } else if (receivedAction?.channelKey == 'notification') {
    Get.to(() => const Notifications());
  } else if (receivedAction?.channelKey == 'library') {
    Get.to(() => const Library());
  }

  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  // BackgroundService.initializeService();
  HttpOverrides.global = MyHttpOverrides();

  await Permission.storage.isDenied.then((value) {
    if (value) {
      Permission.storage.request();
    }
  });

  await GetStorage.init();

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
          print(e);
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
      title: 'aceprex',
      theme: Themes().lightTheme,
      getPages: Routes.routes,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      initialRoute: '/splash',
      defaultTransition: Transition.fadeIn,
    );
  }
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
