import 'package:aceprex/pages/library/component/controller.dart';

import '../../services/widgets/button.dart';
import 'component/controller.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/waiting.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../services/constants/color.dart';
import '../../services/utils/helpers.dart';
import 'comment.dart';

final controller = Get.find<HoodController>();

class SubscribedView extends StatelessWidget {
  final String title;
  final String fileLink;
  final int likes;
  final int fileID;
  final String imagPath;
  final String pdfPath;
  final String author;
  final String description;
  final int dislike;
  final int comment;
  final int principal;
  final int id;
  const SubscribedView(
      {super.key,
      required this.title,
      required this.fileLink,
      required this.likes,
      required this.dislike,
      required this.comment,
      required this.id,
      required this.fileID,
      required this.imagPath,
      required this.pdfPath,
      required this.author,
      required this.description,
      required this.principal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: dark,
              )),
          // title: Text(
          //   title,
          //   style: TextStyle(color: dark),
          // ),
          elevation: 0,
          backgroundColor: Colors.blue[100],
          actions: <Widget>[
            Obx(() => controller.isLibrary.value
                ? const MWaiting()
                : controller.inLibrary.value
                    ? Container()
                    : IconButton(
                        icon: Icon(
                          Icons.save,
                          color: dark,
                        ),
                        onPressed: () {
                          showDialog();
                        },
                      )),
            Obx(() => controller.commentLoad.value
                ? Container()
                : IconButton(
                    onPressed: () {
                      controller.getComment(id);
                      Get.to(() => CommentsScreen(
                            hoodID: id,
                            title: title,
                            id: id,
                          ));
                    },
                    icon: Badge(
                      label: "$comment".toLabel(),
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.comment,
                        size: 17,
                        color: dark,
                      ).padding6,
                    )).padding9),
            IconButton(
                onPressed: () => controller.setLikeDislike('like', id),
                icon: Badge(
                  backgroundColor: Colors.green,
                  label: Obx(() => "${controller.likes.value}".toLabel()),
                  child: Obx(() => controller.likeType.value == 'like'
                      ? const Icon(
                          Icons.thumb_up,
                          size: 17,
                          color: Colors.blue,
                        ).padding6
                      : Icon(
                          Icons.thumb_up,
                          size: 17,
                          color: grey,
                        ).padding6),
                )).padding9,
            IconButton(
                onPressed: () => controller.setLikeDislike('dislike', id),
                icon: Badge(
                  backgroundColor: Colors.red[300],
                  label: Obx(() => "${controller.dislikes.value}".toLabel()),
                  child: Obx(() => controller.likeType.value == 'dislike'
                      ? const Icon(
                          Icons.thumb_down,
                          color: Colors.red,
                          size: 17,
                        ).padding6
                      : Icon(
                          Icons.thumb_down,
                          color: grey,
                          size: 17,
                        ).padding6),
                )).padding9
          ],
        ),
        body: SfPdfViewer.network(
          fileLink,
          controller: controller.pdfViewerController,
          key: controller.pdfViewerKey,
          enableDoubleTapZooming: true,
          canShowScrollHead: true,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        ),
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Next",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.arrow_forward_ios,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                controller.pdfViewerController!.nextPage();
                //controller.animationController!.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Previous",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.arrow_back_ios,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                controller.pdfViewerController!.previousPage();
                // controller.animationController!.reverse();
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Bookmark",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.bookmark,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                controller.pdfViewerKey.currentState?.openBookmarkView();
                controller.animationController!.reverse();
              },
            ),
            Bubble(
              title: "Unsubscribe",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.unsubscribe,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                controller.unSubscribe(id, title, principal);
                controller.animationController!.reverse();
              },
            ),
          ],

          // animation controller
          animation: controller.animation!,

          // On pressed change animation state
          onPress: () => controller.animationController!.isCompleted
              ? controller.animationController!.reverse()
              : controller.animationController!.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          iconData: Icons.group_work,
          backGroundColor: Colors.blue,
        ));
  }

  showDialog() {
    final libCon = Get.find<LibraryController>();
    return Get.defaultDialog(
        title: 'Local library',
        content:
            const Text('Do you want to save it to your local library too?'),
        confirm: MTextButton(
          onTap: () {
            Utils.checkInternet().then((value) async {
              if (!value) {
                Utils().showError("There's no internet connection");
                return;
              } else {
                final bool hasPermission = await libCon.requestPermissions();
                if (hasPermission) {
                  controller.saveToLibrary(id, fileID, title, imagPath, author,
                      description, pdfPath);
                  libCon.savePDF(id.toString(), title, author, description,
                      pdfPath, imagPath);
                  libCon.reload();
                }
              }
            });
            Get.back();
          },
          title: 'Yes',
          color: Colors.teal,
        ),
        cancel: MTextButton(
          onTap: () {
            Utils.checkInternet().then((value) async {
              if (!value) {
                Utils().showError("There's no internet connection");
                return;
              } else {
                final bool hasPermission = await libCon.requestPermissions();
                if (hasPermission) {
                  controller.saveToLibrary(id, fileID, title, imagPath, author,
                      description, pdfPath);

                  libCon.reload();
                }
              }
            });
            Get.back();
          },
          title: 'No',
          color: grey,
        ));
  }
}
