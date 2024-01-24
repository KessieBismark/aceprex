import 'package:aceprex/pages/pdf_view/pdf_text_view.dart';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/model.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

import '../../../services/constants/constant.dart';
import '../../../services/widgets/waiting.dart';

import 'controller.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../services/constants/color.dart';

final libCon = Get.find<LibraryController>();
final db = DatabaseHelper.instance;

class LibView extends StatelessWidget {
  final String title;
  final String fileLink;
  final int fileID;
  final String imagPath;
  final String author;
  final int? page;
  final String description;
  final int id;
  const LibView({
    super.key,
    required this.title,
    required this.fileLink,
    required this.id,
    this.page = 1,
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
          title: title.toAutoLabel(color: light),
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
                                libCon.savePDF(id.toString(), title, author,
                                    description, fileUrl + fileLink, imagPath);
                              },
                              icon: const Icon(Icons.save_alt_rounded),
                            ),
                          ),
                  ).padding9,
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
                    String docFile =
                        await db.downloadAndSavePdf(id, fileUrl + fileLink);
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
        ),
        body: SfPdfViewer.network(
          fileUrl + fileLink,
          controller: libCon.pdfController,
          key: libCon.pdfKey,
          enableDoubleTapZooming: true,
          onDocumentLoaded: (PdfDocumentLoadedDetails detail) {
            libCon.pdfController?.jumpToPage(page!);
          },
          canShowScrollHead: true,
          onPageChanged: (PdfPageChangedDetails details) async {
            await db.insertOrUpdateOnlinePdf(
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
