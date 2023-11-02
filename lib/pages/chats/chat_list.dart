import '../../init_widget/top_nav.dart';
import 'chat.dart';
import 'people.dart';
import 'profile.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import 'component/controller.dart';

class ChatList extends GetView<ChatUIController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: [
                TopBar(
                  title: "Chats",
                  widget: Container(),
                ),
                Flexible(
                  child: Obx(
                    () => controller.chatHeadData.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: "Lets start chatting!!!".toLabel(),
                          )
                        : ListView.builder(
                            itemCount: controller.chatHeadData.length,
                            itemBuilder: (BuildContext context, index) {
                              final data = controller.chatHeadData[index];
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 4), () {
                                        return Get.to(() => ChatUI(
                                              to: data.id,
                                              name: data.name,
                                              isOnline: data.isOnline,
                                              avatar:
                                                  "${fileUrl}users-avatar/${data.profile}",
                                            ));
                                      });
                                    },
                                    leading: SizedBox(
                                      width: 50,
                                      child: InkWell(
                                        onTap: () => Get.to(
                                          () => ChatProfile(
                                            title: data.name,
                                            image: data.profile,
                                          ),
                                        ),
                                        child: Utils.isUrl(
                                                "${fileUrl}users-avatar/${data.profile}")
                                            ? InkWell(
                                                onTap: () => Get.to(
                                                  () => ChatProfile(
                                                      title: data.name,
                                                      image:
                                                          "${fileUrl}users-avatar/${data.profile}"),
                                                ),
                                                child: CircleAvatar(
                                                  maxRadius: 20,
                                                  backgroundImage: NetworkImage(
                                                      "${fileUrl}users-avatar/${data.profile}"),
                                                ),
                                              )
                                            : const CircleAvatar(
                                                maxRadius: 20,
                                                backgroundImage: AssetImage(
                                                    'assets/images/profile.png'),
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      data.name.capitalize!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    subtitle: data.lastMessage!.isEmpty &&
                                            data.attachment!.isNotEmpty
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                const Icon(Icons.image),
                                                SizedBox(
                                                  width: myWidth(context, 2),
                                                  child: "Image".toAutoLabel(),
                                                ),
                                              ])
                                        : Text(
                                            data.lastMessage!,
                                            style: TextStyle(color: grey),
                                          ),
                                    trailing: data.seen != 1 &&
                                            data.to.toString() == Utils.userID
                                        ? Column(
                                            children: [
                                              Text(
                                                Utils.chatFormatTimeAgo(
                                                    data.timeStamp),
                                                style: TextStyle(
                                                    color: data.seen != 1 &&
                                                            data.to.toString() ==
                                                                Utils.userID
                                                        ? primaryLight
                                                        : grey,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              data.unSeenCount! > 0
                                                  ? Badge(
                                                      backgroundColor:
                                                          primaryLight,
                                                      label: data.unSeenCount
                                                          .toString()
                                                          .toLabel(),
                                                    )
                                                  : Container()
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Text(
                                                Utils.chatFormatTimeAgo(
                                                    data.timeStamp),
                                                style: TextStyle(
                                                    color: grey, fontSize: 12),
                                              ),
                                              const Spacer()
                                            ],
                                          ),
                                  ),
                                  const Divider(
                                    indent: 70,
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.getPeople();
              Get.to(() => const PeopleView());
            },
            backgroundColor: primaryColor, // Set the background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Set the border radius
            ),
            child: Icon(
              FontAwesomeIcons.penToSquare,
              size: 20,
              color: light, // Set the icon color
            ),
          )),
    );
  }
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<ChatUIController>();
  return SizedBox(
    width: myWidth(context, 1.4),
    height: 40,
    child: TextField(
      style: TextStyle(color: light),
      controller: controller.searchController,
      onChanged: (text) {
        controller.timer?.cancel();
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.chatHeadData.clear();
          controller.chatHeadData.addAll(controller.chatHead.where((data) {
            var title = data.name.toLowerCase();
            return title.contains(text.toLowerCase());
          }));
        } else {
          controller.isSearching.value = false;
          controller.chatHeadData = controller.chatHead;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Obx(
          () => controller.isSearching.value
              ? IconButton(
                  onPressed: () {
                    controller.chatLoad.value = true;
                    controller.searchController.clear();
                    // controller.chatHeadData.clear();
                    controller.chatHeadData = controller.chatHead;
                    controller.isSearching.value = false;
                    controller.chatLoad.value = false;
                  },
                  icon: Icon(
                    Icons.clear,
                    color: light,
                  ),
                )
              : Icon(
                  Icons.search,
                  color: light,
                ),
        ),
        filled: true,
        fillColor: primaryLight,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        hintText: 'Enter any keyword',
        hintStyle: TextStyle(color: light),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, // Remove the border edges
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, // Remove the border edges
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, // Remove the border edges
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'Search',
        labelStyle: TextStyle(color: light),
      ),
    ),
  );
}
