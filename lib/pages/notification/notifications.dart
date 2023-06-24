import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/widgets/button.dart';
import 'component/controller.dart';


class Notifications extends GetView<NotificationController> {
  const Notifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (() => Get.back()),
        ),
        title: "Notification".toLabel(color: light),
        elevation: 0,
        actions: [
          //searchTextField(context),
          Obx(() => controller.getUnread.value
              ? IconButton(
                  onPressed: () {
                    controller.loadData.value = true;
                    controller.notifyList = controller.notify;
                    controller.loadData.value = false;
                    controller.getUnread.value = false;
                  },
                  icon: Icon(
                    FontAwesomeIcons.filter,
                    size: 20,
                    color: light,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    controller.loadData.value = true;
                    controller.notifyList = controller.notify.where((data) {
                      var status = data.status.toLowerCase();
                      controller.loadData.value = false;
                      controller.getUnread.value = true;
                      return status.contains('unread'.toLowerCase());
                    }).toList();
                    controller.loadData.value = false;
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: light,
                  ),
                ))
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await controller.getData();
          },
          child: Obx(() => controller.loadData.value
              ? ListView.builder(
                  itemCount: controller.notifyList.length,
                  itemBuilder: (BuildContext context, index) {
                    controller.month =
                        controller.notifyList[index].date.month;
                    return Column(
                      children: [
                        index == 0
                            ? Container()
                            : const Divider(
                                indent: 70,
                              ),
                        index == 0
                            ?
                                  "${Utils.myMonth(controller.notifyList[index].date.month)}, ${controller.notifyList[index].date.year}"
                                      .toLabel(color: lightGrey)
                               
                            : controller.notifyList[index - 1].date
                                        .month !=
                                    controller
                                        .notifyList[index].date.month
                                ? "${Utils.myMonth(controller.notifyList[index].date.month)}, ${controller.notifyList[index].date.year}"
                                    .toLabel(color: lightGrey)
                                : Container(),
                        ListTile(
                          onTap: () {
                            viewMessageDialog(
                                context,
                                controller.notifyList[index].title,
                                controller.notifyList[index].hood,
                                controller.notifyList[index].message,
                                controller.notifyList[index].date);
                            controller.updateRead(
                                controller.notifyList[index].id,
                                index);
                          },
                          leading: Container(
                            height: 50,
                            width: myWidth(context, 7),
                            decoration: BoxDecoration(
                                color: primaryLight,
                                // Colors.red[500],
                                borderRadius:
                                    BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                "${controller.weekdayLabels[controller.notifyList[index].date.weekday]}"
                                    .toLabel(
                                        color: light,
                                        bold: controller
                                                        .notifyList[
                                                            index]
                                                        .status ==
                                                    "read" ||
                                                controller.readIDS
                                                    .contains(controller
                                                        .notifyList[
                                                            index]
                                                        .id)
                                            ? false
                                            : true),
                                "${controller.notifyList[index].date.day}"
                                    .toLabel(
                                        color: light,
                                        bold: controller
                                                        .notifyList[
                                                            index]
                                                        .status ==
                                                    "read" ||
                                                controller.readIDS
                                                    .contains(controller
                                                        .notifyList[
                                                            index]
                                                        .id)
                                            ? false
                                            : true)
                              ],
                            ).padding3,
                          ),
                          title: controller.notifyList[index].title
                              .toLabel(
                                  bold: controller.notifyList[index]
                                                  .status ==
                                              "read" ||
                                          controller.readIDS.contains(
                                              controller
                                                  .notifyList[index]
                                                  .id)
                                      ? false
                                      : true),
                          subtitle: controller.notifyList[index].hood
                              .toLabel(color: grey),
                          trailing:
                              "${controller.notifyList[index].date.year}"
                                  .toLabel(color: grey),
                        ),
                      ],
                    );
                  })
              : controller.notifyList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: "You have no notification".toLabel(),
                    )
                  : ListView.builder(
                      itemCount: controller.notifyList.length,
                      itemBuilder: (BuildContext context, index) {
                        controller.month =
                            controller.notifyList[index].date.month;
                        return Column(
                          children: [
                            index == 0
                                ? Container()
                                : const Divider(
                                    indent: 70,
                                  ),
                            index == 0
                                ?
                                      
                                      "${Utils.myMonth(controller.notifyList[index].date.month)}, ${controller.notifyList[index].date.year}"
                                          .toLabel(color: lightGrey)
                                     
                                : controller.notifyList[index - 1]
                                            .date.month !=
                                        controller.notifyList[index]
                                            .date.month
                                    ? "${Utils.myMonth(controller.notifyList[index].date.month)}, ${controller.notifyList[index].date.year}"
                                        .toLabel(color: lightGrey)
                                    : Container(),
                            ListTile(
                              onTap: () {
                                viewMessageDialog(
                                    context,
                                    controller
                                        .notifyList[index].title,
                                    controller.notifyList[index].hood,
                                    controller
                                        .notifyList[index].message,
                                    controller
                                        .notifyList[index].date);
                                controller.updateRead(
                                    controller.notifyList[index].id,
                                    index);
                              },
                              leading: Container(
                                height: 50,
                                width: myWidth(context, 7),
                                decoration: BoxDecoration(
                                    color: primaryLight,
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    "${controller.weekdayLabels[controller.notifyList[index].date.weekday]}"
                                        .toLabel(
                                            color: light,
                                            bold: controller
                                                            .notifyList[
                                                                index]
                                                            .status ==
                                                        "read" ||
                                                    controller.readIDS
                                                        .contains(controller
                                                            .notifyList[
                                                                index]
                                                            .id)
                                                ? false
                                                : true),
                                    "${controller.notifyList[index].date.day}"
                                        .toLabel(
                                            color: light,
                                            bold: controller
                                                            .notifyList[
                                                                index]
                                                            .status ==
                                                        "read" ||
                                                    controller.readIDS
                                                        .contains(controller
                                                            .notifyList[
                                                                index]
                                                            .id)
                                                ? false
                                                : true)
                                  ],
                                ).padding3,
                              ),
                              title: controller
                                  .notifyList[index].title
                                  .toLabel(
                                      bold: controller
                                                      .notifyList[
                                                          index]
                                                      .status ==
                                                  "read" ||
                                              controller.readIDS
                                                  .contains(controller
                                                      .notifyList[
                                                          index]
                                                      .id)
                                          ? false
                                          : true),
                              subtitle: controller
                                  .notifyList[index].hood
                                  .toLabel(color: grey),
                              trailing:
                                  "${controller.notifyList[index].date.year}"
                                      .toLabel(color: grey),
                            ),
                          ],
                        );
                      }))),
    );
  }
}

viewMessageDialog(
    context, String title, String hood, String message, DateTime date) {
  Get.defaultDialog(
      title: title,
      barrierDismissible: false,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hood.toLabel(
              color: Colors.blue[200],
            ),
            date.dateTimeFormatString().toString().toLabel(color: lightGrey),
            const SizedBox(
              height: 5,
            ),
            "Message".toLabel(bold: true),
            SizedBox(
                width: myWidth(context, 1.3),
                height: myHeight(context, 5),
                child: Text(Utils.removeHtmlTags(message))),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                MButton(
                  onTap: Get.back,
                  type: ButtonType.close,
                )
              ],
            )
          ],
        ),
      ));
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<NotificationController>();
  return SizedBox(
    width: myWidth(context, 1.4),
    height: 40,
    child: TextField(
      style: TextStyle(color: dark),
      controller: controller.searchController,
      onChanged: (text) {
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.loadData.value = true;

          Future.delayed(const Duration(microseconds: 300)).then((value) {
            controller.notifyList = controller.notify.where((data) {
              var title = data.title.toLowerCase();
              var from = data.from.toLowerCase();
              var status = data.status.toLowerCase();
              var hood = data.hood.toLowerCase();
              var date = data.date;

              return title.contains(text.toLowerCase()) ||
                  from.contains(text.toLowerCase()) ||
                  status.contains(text.toLowerCase()) ||
                  hood.contains(text.toLowerCase()) ||
                  date.toString().contains(text);
            }).toList();
          });
          controller.loadData.value = false;
        } else {
          controller.loadData.value = true;
          controller.isSearching.value = false;
          controller.loadData.value = false;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Obx(() => controller.isSearching.value
            ? IconButton(
                onPressed: () {
                  controller.loadData.value = true;
                  controller.notifyList = controller.notify;
                  controller.searchController.clear();
                  controller.isSearching.value = false;
                  controller.loadData.value = false;
                },
                icon: Icon(
                  Icons.clear,
                  color: grey,
                ),
              )
            : Icon(
                Icons.search,
                color: grey,
              )),
        filled: true,
        fillColor: Colors.blue[100],
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
        labelStyle: TextStyle(color: grey),
      ),
    ),
  );
}
