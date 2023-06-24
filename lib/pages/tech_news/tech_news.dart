import 'package:aceprex/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../init_widget/top_nav.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import 'component/controller.dart';
import 'news_View.dart';

class TechNews extends GetView<TechNewsController> {
  const TechNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            controller.getData();
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                TopBar(
                  title: "News",
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          searchTextField(context),
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(Icons.calendar_today, color: light))
                        ],
                      ).hMargin9.hMargin9,
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => !controller.isInternet.value
                      ? Expanded(
                          child: Center(
                            child: TextButton(
                              child: "Tap to refresh".toLabel(),
                              onPressed: () => controller.reload(),
                            ),
                          ),
                        )
                      : controller.loadData.value
                          ? const NewsViewShimmer()
                          : controller.techNewsList.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  child: "No News Article!".toLabel())
                              : NewsView(data: controller.techNewsList)),
                )
              ],
            ),
          )),
    );
  }
}

SizedBox searchTextField(BuildContext context) {
  final controller = Get.find<TechNewsController>();
  return SizedBox(
    width: myWidth(context, 1.2),
    height: 40,
    child: TextField(
      style: TextStyle(color: light),
      controller: controller.searchController,
      onChanged: (text) {
        if (text.isNotEmpty) {
          controller.isSearching.value = true;
          controller.loadData.value = true;
          Future.delayed(const Duration(microseconds: 300)).then(
            (value) {
              controller.techNewsList = controller.techNews.where(
                (data) {
                  var title = data.title.toLowerCase();
                  var slug = data.slug.toLowerCase();
                  var newsDate = data.date.toString();
                  return title.contains(text.toLowerCase()) ||
                      newsDate.contains(text) ||
                      slug.contains(text.toLowerCase());
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
