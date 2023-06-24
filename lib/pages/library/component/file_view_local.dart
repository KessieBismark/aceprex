import 'dart:io';

import '../../hood/component/controller.dart';
import 'controller.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../services/constants/color.dart';

final libCon = Get.find<LibraryController>();

class LibViewLocal extends StatelessWidget {
  final String title;
  final String fileLink;
  final String imagPath;
  final String author;
  final String description;
  final int id;
  const LibViewLocal({
    super.key,
    required this.title,
    required this.fileLink,
    required this.id,
    required this.imagPath,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HoodController>();
    libCon.isLibraryIdExists(id);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: light,
              )),
          title: Text(
            title,
            style: TextStyle(color: light),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: SfPdfViewer.file(
          File(fileLink),
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
              bubbleColor:primaryLight,
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
              bubbleColor: primaryLight,
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
              bubbleColor: primaryLight,
              icon: Icons.bookmark,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                controller.pdfViewerKey.currentState?.openBookmarkView();
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
          backGroundColor:primaryLight,
        ));
  }
}
