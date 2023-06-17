import 'component/controller.dart';
import '../services/constants/color.dart';
import '../services/utils/helpers.dart';
import '../services/widgets/extension.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/blog/blog.dart';
import '../pages/chats/chat_list.dart';
import '../pages/hood/hood.dart';
import '../pages/library/library.dart';
import '../pages/notification/notifications.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Obx(() => IndexedStack(
              index: controller.tabIndex.value,
              children: const [
                // Report()
                Hood(),
                Library(),
                Blog(),
                Notifications(),
                ChatList(),
              ],
            )),
        bottomNavigationBar: CurvedNavigationBar(
          index: controller.tabIndex.value,
          height: 50,
          backgroundColor: trans,
          animationDuration: const Duration(milliseconds: 300),
          color: Colors.blue[200]!,
          onTap: (value) => controller.changeTabIndex(value),
          items: [
            Tooltip(
                message: "Hood",
                child: Icon(Icons.book_online, color: dark, size: 20)),
            Tooltip(
                message: "Libraries",
                child: Icon(Icons.library_books, color: dark, size: 20)),
            Tooltip(
                message: "Artciles",
                child: Icon(Icons.article, color: dark, size: 20)),
            Tooltip(
                message: "Notification",
                child: Obx(() => Utils.messageCount.value == 0
                    ? Icon(Icons.notifications, color: dark, size: 20)
                    : Badge(
                        label:
                            "${Utils.messageCount.value}".toLabel(color: light),
                        child:
                            Icon(Icons.notifications, color: dark, size: 20)))),
            Tooltip(
                message: "Chat",
                child: Obx(() => Utils.unReadChat.value == 0
                    ? Icon(Icons.chat_bubble, color: dark, size: 20)
                    : Badge(
                        label: "${Utils.unReadChat.value}".toLabel(color: light),
                        child: Icon(Icons.chat_bubble, color: dark, size: 20)))),
          ],
        ),
      ),
    );
  }
}

class IconItem extends StatelessWidget {
  final Icon icon;
  final Text text;
  const IconItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [icon, text],
    );
  }
}
