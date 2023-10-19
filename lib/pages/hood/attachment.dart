import 'package:aceprex/pages/hood/component/controller.dart';
import 'package:aceprex/services/constants/color.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:aceprex/services/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/shimmer_placeholders.dart';
import 'file_view.dart';

class Attachments extends GetView<HoodController> {
  final String hood;
  final int hoodID;
  final int authorID;
  const Attachments(
      {super.key,
      required this.authorID,
      required this.hood,
      required this.hoodID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: hood.toAutoLabel(color: light),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getSubscribed(hoodID);
        },
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Obx(
                () => controller.loadHood.value ? hoodShimmer() : hoodItems())),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryLight,
        onPressed: () => controller.unSubscribe(hoodID, hood, authorID),
        child: const Tooltip(
          message: "Unsubscribe",
          child: Icon(Icons.logout),
        ),
      ),
    );
  }

  ListView hoodShimmer() {
    return ListView.builder(
      itemBuilder: (context, index) => GlassContainer(
        width: double.infinity,
        height: 100,
        widget: Shimmer.fromColors(
          baseColor: const Color.fromARGB(115, 158, 158, 158),
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: ListTile(
            leading: Container(
              height: 50,
              width: myWidth(context, 7),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
            title: const TitlePlaceholder(
              width: double.infinity,
            ),
            subtitle: const TitlePlaceholder(
              width: double.infinity,
            ),
          ),
        ),
      ).padding3,
    );
  }

  ListView hoodItems() {
    return ListView.builder(
      itemCount: controller.subscribedList.length,
      itemBuilder: (BuildContext context, index) => ListTile(
        onTap: () {
          controller.checkSaved(controller.hoodList[index].id.toString());
          controller.getLikesDislike(controller.subscribedList[index].id);
          controller.read(controller.subscribedList[index].id);
          if (controller.subscribedList[index].fileLink.isNotEmpty) {
            Get.to(
              () => SubscribedView(
                principal: controller.subscribedList[index].principal,
                title: controller.subscribedList[index].title,
                fileLink: controller.subscribedList[index].fileLink,
                likes: controller.subscribedList[index].likes,
                dislike: controller.subscribedList[index].disLike,
                comment: controller.subscribedList[index].comment,
                id: controller.subscribedList[index].id,
                author: controller.subscribedList[index].author,
                fileID: controller.subscribedList[index].fileID,
                imagPath: fileUrl + controller.subscribedList[index].image,
                pdfPath: fileUrl + controller.subscribedList[index].fileLink,
                description: controller.subscribedList[index].describtion,
              ),
            );
          } else {
            Utils().showError("File link is incorrect");
          }
        },
        leading: Container(
          height: 50,
          width: myWidth(context, 7),
          decoration: BoxDecoration(
              color: primaryLight,
              // Colors.red[500],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              '${controller.monthLabels[controller.subscribedList[index].date.month]}'
                  .toAutoLabel(
                color: light,
              ),
              "${controller.subscribedList[index].date.day}".toAutoLabel(
                color: light,
              )
            ],
          ).padding3,
        ),
        title: controller.subscribedList[index].title.toAutoLabel(bold: true),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.subscribedList[index].author.toAutoLabel(color: grey),
            controller.subscribedList[index].describtion.toAutoLabel(color: grey),
          ],
        ),
        trailing: "${controller.subscribedList[index].date.year}"
            .toAutoLabel(color: grey),
      ).card,
    );
  }
}
