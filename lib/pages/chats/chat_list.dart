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
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        searchTextField(context),
                        IconButton(
                          onPressed: () {
                            controller.getPeople();
                            Get.to(
                              () => const PeopleView(),
                            );
                          },
                          icon: Icon(
                            FontAwesomeIcons.penToSquare,
                            color: light,
                            size: 20,
                          ),
                        ),
                        Obx(
                          () => controller.getUnread.value
                              ? IconButton(
                                  onPressed: () {
                                    controller.chatLoad.value = true;
                                    controller.chatListData =
                                        controller.chatList;
                                    controller.chatLoad.value = false;
                                    controller.getUnread.value = false;
                                    controller.startTimer();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.filter,
                                    size: 20,
                                    color: light,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    controller.chatLoad.value = true;
                                    controller.chatListData =
                                        controller.chatList.where((data) {
                                      var status = data.lastMessageSeen;
                                      controller.chatLoad.value = false;
                                      controller.getUnread.value = true;
                                      return status
                                          .toString()
                                          .contains('0'.toLowerCase());
                                    }).toList();
                                    controller.timer!.cancel();
                                    controller.chatLoad.value = false;
                                  },
                                  icon: Icon(
                                    Icons.filter_list,
                                    color: light,
                                  ),
                                ),
                        ),
                      ],
                    ).hMargin9.hMargin9,
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Obx(
                  () => controller.chatLoad.value
                      ? ListView.builder(
                          itemCount: controller.chatListData.length,
                          itemBuilder: (BuildContext context, index) {
                            final data = controller.chatListData[index];
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.to(() => ChatUI(
                                          to: data.id,
                                          name: data.name,
                                          isOnline: data.isOnline,
                                          avatar: fileUrl + data.fromImage!,
                                        ));
                                  },
                                  leading: Utils.isUrl(data.fromImage!)
                                      ? InkWell(
                                          onTap: () => Get.to(
                                            () => ChatProfile(
                                                title: data.name,
                                                image:
                                                    fileUrl + data.fromImage!),
                                          ),
                                          child: CircleAvatar(
                                            maxRadius: 20,
                                            backgroundImage: NetworkImage(
                                                fileUrl + data.fromImage!),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          maxRadius: 20,
                                          backgroundImage: AssetImage(
                                              'assets/images/profile.png'),
                                        ),
                                  title: Text(
                                    data.name.capitalize!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    data.lastMessage!,
                                    style: TextStyle(color: grey),
                                  ),
                                  trailing: data.lastMessageSeen != 1 &&
                                          data.toID.toString() == Utils.userID
                                      ? Column(
                                          children: [
                                            Text(
                                              Utils.chatFormatTimeAgo(
                                                  data.lastDate),
                                              style: TextStyle(
                                                  color: data.lastMessageSeen !=
                                                              1 &&
                                                          data.toID
                                                                  .toString() ==
                                                              Utils.userID
                                                      ? primaryLight
                                                      : grey,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            data.unRead > 0
                                                ? Badge(
                                                    backgroundColor:
                                                        primaryLight,
                                                    label: data.unRead
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
                                                  data.lastDate),
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
                        )
                      : controller.chatList.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              child: "Lets start chatting!!!".toLabel(),
                            )
                          : ListView.builder(
                              itemCount: controller.chatListData.length,
                              itemBuilder: (BuildContext context, index) {
                                final data = controller.chatListData[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.to(() => ChatUI(
                                              to: data.id,
                                              name: data.name,
                                              isOnline: data.isOnline,
                                              avatar: fileUrl + data.fromImage!,
                                            ));
                                      },
                                      leading: Utils.isUrl(data.fromImage!)
                                          ? InkWell(
                                              onTap: () => Get.to(
                                                () => ChatProfile(
                                                    title: data.name,
                                                    image: fileUrl +
                                                        data.fromImage!),
                                              ),
                                              child: CircleAvatar(
                                                maxRadius: 20,
                                                backgroundImage: NetworkImage(
                                                    fileUrl + data.fromImage!),
                                              ),
                                            )
                                          : const CircleAvatar(
                                              maxRadius: 20,
                                              backgroundImage: AssetImage(
                                                  'assets/images/profile.png'),
                                            ),
                                      title: Text(
                                        data.name.capitalize!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        data.lastMessage!,
                                        style: TextStyle(color: grey),
                                      ),
                                      trailing: data.lastMessageSeen != 1 &&
                                              data.toID.toString() ==
                                                  Utils.userID
                                          ? Column(
                                              children: [
                                                Text(
                                                  Utils.chatFormatTimeAgo(
                                                      data.lastDate),
                                                  style: TextStyle(
                                                      color: data.lastMessageSeen !=
                                                                  1 &&
                                                              data.toID
                                                                      .toString() ==
                                                                  Utils.userID
                                                          ? primaryLight
                                                          : grey,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                data.unRead > 0
                                                    ? Badge(
                                                        backgroundColor:
                                                            primaryLight,
                                                        label: data.unRead
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
                                                      data.lastDate),
                                                  style: TextStyle(
                                                      color: grey,
                                                      fontSize: 12),
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
      ),
    );
  }
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<ChatUIController>();
  return SizedBox(
    width: myWidth(context, 1.7),
    height: 40,
    child: TextField(
      style: TextStyle(color: light),
      controller: controller.searchController,
      onChanged: (text) {
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.chatLoad.value = true;
          Future.delayed(const Duration(microseconds: 300)).then(
            (value) {
              controller.chatListData = controller.chatList.where(
                (data) {
                  var title = data.name.toLowerCase();
                  return title.contains(text.toLowerCase());
                },
              ).toList();
            },
          );
          controller.chatLoad.value = false;
        } else {
          controller.chatLoad.value = true;
          controller.isSearching.value = false;
          controller.chatLoad.value = false;
          controller.startTimer();
        }
      },
      decoration: InputDecoration(
        suffixIcon: Obx(
          () => controller.isSearching.value
              ? IconButton(
                  onPressed: () {
                    controller.chatLoad.value = true;
                    controller.chatListData = controller.chatList;
                    controller.searchController.clear();
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
        hintStyle: const TextStyle(color: Colors.grey),
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
