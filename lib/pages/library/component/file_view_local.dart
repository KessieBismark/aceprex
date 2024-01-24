import 'dart:io';

import 'package:aceprex/pages/pdf_view/pdf_text_view.dart';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/model.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:aceprex/services/widgets/waiting.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

import '../../hood/component/controller.dart';
import 'controller.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../services/constants/color.dart';

final libCon = Get.find<LibraryController>();
final db = DatabaseHelper.instance;

class LibViewLocal extends StatelessWidget {
  final String title;
  final String fileLink;
  final String imagPath;
  final String author;
  final String description;
  final int id;
  final int? page;
  const LibViewLocal({
    super.key,
    required this.title,
    required this.fileLink,
    required this.id,
    this.page = 1,
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
          title: title.toAutoLabel(color: light),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    List<String> textList = <String>[];
                    Get.defaultDialog(
                        title: "",
                        barrierDismissible: false,
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Processing file for easy reading."),
                            Text("(text only)"),
                            SizedBox(
                              height: 5,
                            ),
                            MWaiting()
                          ],
                        ));
                    String docFile = fileLink;
                    if (docFile.isEmpty) {
                      Get.back();
                      Utils().showError("Could not process file.");
                    } else {
                      textList = await ReadPdfText.getPDFtextPaginated(docFile);
                      Get.back();
                      Get.to(() => ClearText(
                            title: title,
                            textList: textList,
                            initialPage: page!,
                          ));
                    }
                  } on PlatformException {
                    Get.back();
                    print('Failed to get PDF text.');
                  }
                },
                icon: Icon(Icons.zoom_out_map, color: light))
          ],
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: SfPdfViewer.file(
          File(fileLink),
          controller: controller.pdfViewerController,
          key: controller.pdfViewerKey,
          enableDoubleTapZooming: true,
          onDocumentLoaded: (PdfDocumentLoadedDetails detail) {
            controller.pdfViewerController?.jumpToPage(page!);
          },
          canShowScrollHead: true,
          onPageChanged: (PdfPageChangedDetails details) async {
            await db.insertOrUpdateOpenedPdf(
                OpenedPdf(pdfInfoId: id, lastPageRead: details.newPageNumber));
          },
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
          backGroundColor: primaryLight,
        ));
  }
}
