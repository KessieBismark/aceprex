import 'dart:io';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/utils/themes.dart';

import '../../services/widgets/waiting.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/glass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../init_widget/top_nav.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/widgets/shimmer_placeholders.dart';
import 'component/controller.dart';
import 'component/file_view.dart';
import 'component/file_view_local.dart';

final db = DatabaseHelper.instance;

class Library extends GetView<LibraryController> {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.reload();
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Column(
                children: [
                  TopBar(
                    title: "Libraries",
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            searchTextField(context),
                          ],
                        ).hMargin9.hMargin9,
                        TabBar(
                          indicatorWeight: 5,
                          indicatorColor: primaryLight,
                          tabs: [
                            Tab(
                              child: "Online".toLabel(
                                color: light,
                              ),
                            ),
                            Tab(
                              child: "Offline".toLabel(
                                color: light,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Obx(() => !controller.isInternet.value
                            ? Center(
                                child: TextButton(
                                  child: "Tap to refresh".toLabel(),
                                  onPressed: () => controller.reload(),
                                ),
                              )
                            : controller.loadData.value
                                ? onLineListShimmer()
                                : onLineList()),
                        Obx(
                          () => !controller.isInternet.value
                              ? Center(
                                  child: TextButton(
                                    child: "Tap to refresh".toLabel(),
                                    onPressed: () => controller.reload(),
                                  ),
                                )
                              : controller.loadLocal.value
                                  ? onLineListShimmer()
                                  : onffLineList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView onLineList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.libraryList.length,
      itemBuilder: (BuildContext context, index) {
        final data = controller.libraryList[index];
        controller.isLibraryIdExists(data.id);
        return Material(
          elevation: 3,
          child:
              //  GlassContainer(
              //   width: double.infinity,
              //   height: 80,
              //   widget:
              ListTile(
            contentPadding: const EdgeInsets.only(left: 5),
            onTap: () async {
              int page = await db.getLastPageOnline(data.id);
              Get.to(
                () => LibView(
                  title: data.title,
                  id: data.id,
                  page: page,
                  fileID: data.fileID,
                  imagPath: data.image,
                  fileLink: data.fileLink,
                  author: data.author,
                  description: data.description,
                ),
              );
            },
            leading: SizedBox(
              width: 80,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: fileUrl + data.image,
                fit: BoxFit.fill,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color.fromARGB(115, 158, 158, 158),
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Container(
                    height: myHeight(context, 2),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            title: data.title.toLabel(
              bold: true,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.author,
                  style: const TextStyle(color: primaryLight),
                ),
              ],
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => controller.checkLdb.value
                        ? controller.checkLocalDB(data.id)
                            ? Container()
                            : Obx(() => controller.saveLocal.value &&
                                    controller.deleteOnline == data.id
                                ? const MWaiting()
                                : Tooltip(
                                    message: "Save to phone",
                                    child: IconButton(
                                        onPressed: () async {
                                          controller.deleteOnline = data.id;
                                          controller.savePDF(
                                              data.id.toString(),
                                              data.title,
                                              data.author,
                                              data.description,
                                              fileUrl + data.fileLink,
                                              fileUrl + data.image);
                                        },
                                        icon:
                                            const Icon(Icons.save_alt_rounded)),
                                  ))
                        : controller.checkLocalDB(data.id)
                            ? Container()
                            : Obx(
                                () => controller.saveLocal.value &&
                                        controller.deleteOnline == data.id
                                    ? const MWaiting()
                                    : Tooltip(
                                        message: "Save to phone",
                                        child: IconButton(
                                          color:
                                              ThemeService().isSavedDarkMode()
                                                  ? light
                                                  : dark,
                                          onPressed: () async {
                                            controller.deleteOnline = data.id;
                                            controller.savePDF(
                                                data.id.toString(),
                                                data.title,
                                                data.author,
                                                data.description,
                                                fileUrl + data.fileLink,
                                                fileUrl + data.image);
                                          },
                                          icon: const Icon(
                                              Icons.save_alt_rounded),
                                        ),
                                      ),
                              ),
                  ),
                  Obx(
                    () => controller.isDeleteOnline.value &&
                            controller.deleteOnline == data.id
                        ? const MWaiting()
                        : IconButton(
                            onPressed: () {
                              controller.deleteOnlineLib(data.id, data.fileID);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // ),
        )
            .animate()
            .fadeIn(duration: 900.ms, delay: 200.ms)
            .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
            .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
            .padding9;
      },
    );
  }

  ListView onffLineList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.pdfsData.length,
      itemBuilder: (BuildContext context, index) {
        final data = controller.pdfsData[index];
        return Material(
          elevation: 3,
          child:
              //  GlassContainer(
              //   width: double.infinity,
              //   height: 80,
              //   widget:
              ListTile(
            contentPadding: const EdgeInsets.only(left: 5),

            onTap: () async {
              int page = await db.getLastPageLibrary(data.id!);
              Get.to(
                () => LibViewLocal(
                  title: data.title,
                  id: data.id!,
                  page: page,
                  imagPath: data.imagePath,
                  fileLink: data.pdfPath,
                  author: data.author,
                  description: data.description,
                ),
              );
            },
            leading:
                SizedBox(width: 80, child: Image.file(File(data.imagePath))),
            title: data.title.toLabel(bold: true, fontsize: 20),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.author,
                  style: const TextStyle(color: primaryLight),
                ),
              ],
            ),
            trailing: Obx(
              () => controller.isDelete.value && controller.deleteID == data.id!
                  ? const MWaiting()
                  : IconButton(
                      onPressed: () {
                        controller.deletePDF(
                            data.id!, data.pdfPath, data.imagePath);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
            ),
            //    ),
          ),
        )
            .animate()
            .fadeIn(duration: 900.ms, delay: 200.ms)
            .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
            .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
            .padding9;
      },
    );
  }

  ListView onLineListShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, index) {
        return GlassContainer(
          width: double.infinity,
          height: 80,
          widget: Shimmer.fromColors(
            baseColor: const Color.fromARGB(115, 158, 158, 158),
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: ListTile(
              leading: Container(
                height: myHeight(context, 8),
                width: myWidth(context, 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ).padding6.hMargin3,
              title: const TitlePlaceholder(
                width: double.infinity,
              ),
              subtitle: const TitlePlaceholder(
                width: double.infinity,
              ),
            ),
          ),
        ).padding9;
      },
    );
  }
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<LibraryController>();
  return SizedBox(
    width: myWidth(context, 1.2),
    height: 40,
    child: TextField(
      style: TextStyle(color: light),
      controller: controller.searchController,
      onChanged: (text) {
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.loadLocal.value = true;

          Future.delayed(const Duration(microseconds: 300)).then((value) {
            controller.pdfsData = controller.pdfs.where((data) {
              var title = data.title.toLowerCase();
              var author = data.author.toLowerCase();

              return title.contains(text.toLowerCase()) ||
                  author.contains(text.toLowerCase());
            }).toList();
          });
          controller.loadLocal.value = false;
        } else {
          controller.loadData.value = true;
          controller.isSearching.value = false;
          controller.loadLocal.value = false;
        }
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.loadData.value = true;
          Future.delayed(const Duration(microseconds: 300)).then(
            (value) {
              controller.libraryList = controller.library.where(
                (data) {
                  var title = data.title.toLowerCase();
                  var author = data.author.toLowerCase();
                  return title.contains(text.toLowerCase()) ||
                      author.contains(text.toLowerCase());
                },
              ).toList();
            },
          );
          controller.loadData.value = false;
        } else {
          controller.loadData.value = true;
          controller.isSearching.value = false;
          controller.loadData.value = false;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Obx(
          () => controller.isSearching.value
              ? IconButton(
                  onPressed: () {
                    controller.loadData.value = true;
                    controller.loadLocal.value = true;
                    controller.loadLocal.value = true;
                    controller.libraryList = controller.library;
                    controller.pdfsData = controller.pdfs;
                    controller.searchController.clear();
                    controller.isSearching.value = false;
                    controller.loadData.value = false;
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
