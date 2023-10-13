import '../../../services/constants/constant.dart';
import '../../../services/widgets/waiting.dart';

import 'controller.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../services/constants/color.dart';

final libCon = Get.find<LibraryController>();

class LibView extends StatelessWidget {
  final String title;
  final String fileLink;
  final int fileID;
  final String imagPath;
  final String author;
  final String description;
  final int id;
  const LibView({
    super.key,
    required this.title,
    required this.fileLink,
    required this.id,
    required this.fileID,
    required this.imagPath,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
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
          actions: <Widget>[
            libCon.checkLocalDB(id)
                ? Container()
                : Obx(
                    () => libCon.saveLocal.value
                        ? const MWaiting()
                        : Tooltip(
                            message: "Save to phone",
                            child: IconButton(
                                color: light,
                                onPressed: () async {
                                  libCon.savePDF(
                                      id.toString(),
                                      title,
                                      author,
                                      description,
                                      fileUrl + fileLink,
                                      imagPath);
                                },
                                icon: const Icon(Icons.save_alt_rounded))),
                  )
          ],
        ),
        body: SfPdfViewer.network(
          fileUrl + fileLink,
          controller: libCon.pdfController,
          key: libCon.pdfKey,
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
              bubbleColor: primaryLight,
              icon: Icons.arrow_forward_ios,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                libCon.pdfController!.nextPage();
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
                libCon.pdfController!.previousPage();
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
                libCon.pdfKey.currentState?.openBookmarkView();
                libCon.animateController!.reverse();
              },
            ),
          ],

          // animation controller
          animation: libCon.animate!,
          // On pressed change animation state
          onPress: () => libCon.animateController!.isCompleted
              ? libCon.animateController!.reverse()
              : libCon.animateController!.forward(),
          // Floating Action button Icon color
          iconColor: Colors.white,
          // Flaoting Action button Icon
          iconData: Icons.group_work,
          backGroundColor: primaryLight,
        ));
  }
}
