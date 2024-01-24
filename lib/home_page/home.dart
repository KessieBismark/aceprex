import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import '../pages/tech_news/tech_news.dart';
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

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      snackBar: const SnackBar(
        content: Text("Tap again to exit !"),
      ),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          leading: Container(),
          backgroundColor: primaryColor,
        ),
        body: Obx(
          () => IndexedStack(
            index: controller.tabIndex.value,
            children: const [
              Hood(),
              Library(),
              TechNews(),
              Blog(),
              ChatList(),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: controller.tabIndex.value,
          height: 50,
          backgroundColor: trans,
          animationDuration: const Duration(milliseconds: 300),
          color: primaryColor,
          onTap: (value) => controller.changeTabIndex(value),
          items: [
            Tooltip(
                message: "Hood",
                child: Icon(Icons.book_online, color: light, size: 20)),
            Tooltip(
                message: "Libraries",
                child:
                    Icon(Icons.download_for_offline, color: light, size: 20)),
            Tooltip(
                message: "Tech News",
                child: Icon(Icons.newspaper, color: light, size: 20)),
            Tooltip(
                message: "Artciles",
                child: Icon(Icons.article, color: light, size: 20)),
            Tooltip(
                message: "Chat",
                child: Obx(() => Utils.unReadChat.value == 0
                    ? Icon(Icons.chat_bubble, color: light, size: 20)
                    : Badge(
                        label:
                            "${Utils.unReadChat.value}".toLabel(color: light),
                        child:
                            Icon(Icons.chat_bubble, color: light, size: 20)))),
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
