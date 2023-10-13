import 'chat.dart';
import 'component/controller.dart';
import 'image_viewer.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/shimmer_placeholders.dart';

class PeopleView extends GetView<ChatUIController> {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            controller.searchController.clear();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: light,
          ),
        ),
        actions: [searchTextField(context).padding9],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getPeople();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SafeArea(
            child: Obx(() => controller.peopleLoad.value
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, index) {
                      return Shimmer.fromColors(
                        baseColor: const Color.fromARGB(115, 158, 158, 158),
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                height: 50,
                                width: myWidth(context, 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              title: const TitlePlaceholder(
                                width: double.infinity,
                              ),
                              subtitle: const TitlePlaceholder(
                                width: 200,
                              ),
                            ),
                            const Divider(
                              indent: 70,
                            ),
                          ],
                        ),
                      );
                    })
                : ListView.builder(
                    itemCount: controller.peopleList.length,
                    itemBuilder: (BuildContext context, index) {
                      final data = controller.peopleList[index];
                      return Column(
                        children: [
                          ListTile(
                              onTap: () {
                                Get.to(() => ChatUI(
                                    to: data.id,
                                    name: data.name,
                                    avatar:
                                        "${fileUrl}users-avatar/${data.avatar}",
                                    isOnline: data.isOnline));
                              },
                              leading: Utils.isUrl(
                                      "${fileUrl}users-avatar/${data.avatar!}")
                                  ? InkWell(
                                      onTap: () => Get.to(() => ImageViewer(
                                          imageUrl:
                                              "${fileUrl}users-avatar/${data.avatar!}",
                                          tag: data.name)),
                                      child: CircleAvatar(
                                          maxRadius: 20,
                                          backgroundImage: NetworkImage(
                                              "${fileUrl}users-avatar/${data.avatar!}")),
                                    )
                                  : const CircleAvatar(
                                      maxRadius: 20,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile.png'),
                                    ),
                              title: Text(
                                data.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              subtitle: Text(
                                data.role!,
                                style: TextStyle(color: grey),
                              ),
                              trailing: data.isOnline == 1
                                  ? const Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: primaryLight,
                                    )
                                  : null),
                          const Divider(
                            indent: 70,
                          )
                        ],
                      );
                    },
                  )),
          ),
        ),
      ),
    );
  }
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<ChatUIController>();
  return SizedBox(
    width: myWidth(context, 1.3),
    height: 40,
    child: TextField(
      style: TextStyle(color: light),
      controller: controller.searchController,
      onChanged: (text) {
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.peopleLoad.value = true;

          Future.delayed(const Duration(microseconds: 300)).then((value) {
            controller.peopleList = controller.people.where((data) {
              var title = data.name.toLowerCase();

              return title.contains(text.toLowerCase());
            }).toList();
          });
          controller.peopleLoad.value = false;
        } else {
          controller.peopleLoad.value = true;
          controller.isSearching.value = false;
          controller.peopleLoad.value = false;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Obx(() => controller.isSearching.value
            ? IconButton(
                onPressed: () {
                  controller.peopleLoad.value = true;
                  controller.peopleList = controller.people;
                  controller.searchController.clear();
                  controller.isSearching.value = false;
                  controller.peopleLoad.value = false;
                },
                icon: Icon(
                  Icons.clear,
                  color: light,
                ),
              )
            : Icon(
                Icons.search,
                color: light,
              )),
        filled: true,
        fillColor: primaryLight,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        hintText: 'Enter a person\'s name',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, // Remove the border edges
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          // borderSide: const BorderSide(color: Colors.grey),
          borderSide: BorderSide.none, // Remove the border edges
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, // Remove the border edges

          // borderSide: BorderSide(color: grey),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'Search',
        labelStyle: TextStyle(color: light),
      ),
    ),
  );
}
