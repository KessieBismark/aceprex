import 'blog_details.dart';
import '../../services/constants/color.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';
import '../../shimmer/blog_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../init_widget/my_card.dart';
import '../../init_widget/tabs.dart';
import '../../init_widget/top_nav.dart';
import '../../shimmer/my_card.dart';
import 'component/controller.dart';

class Blog extends GetView<ArticleController> {
  const Blog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.reload();
        },
        child: Column(
          children: [
            TopBar(
              title: "Features",
              widget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Categories".toLabel(bold: true, color: light),
                      InkWell(
                          onTap: () {
                            controller.curIndex.value = -1;
    
                            controller.getData();
                            controller.cIndex.value =
                                !controller.cIndex.value;
                          },
                          child:
                              "View All".toLabel(bold: true, color: light))
                    ],
                  ).hPadding9,
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 50,
                    child: Obx(
                      () => !controller.isInternet.value
                          ? Container()
                          : controller.loadCat.value
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (BuildContext context,
                                          index) =>
                                      BlogCatShimmer(
                                        count: 5,
                                        widget: Container(
                                          height: 30,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(width: 2),
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      30),),
                                        ).padding9,
                                      ),)
                              : Obx(() => !controller.isInternet.value
                                  ? Container()
                                  : controller.cIndex.value
                                      ? ListView.builder(
                                          padding:
                                              const EdgeInsets.all(0),
                                          scrollDirection:
                                              Axis.horizontal,
                                          itemCount:
                                              controller.category.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                      index) =>
                                                  TabButton(
                                            controller: controller,
                                            index: index,
                                            ontap: () {
                                              controller.curIndex.value =
                                                  index;
                                              controller.cIndex.value =
                                                  !controller
                                                      .cIndex.value;
                                              controller.getData(
                                                  id: controller
                                                      .category[index]
                                                      .id);
                                            },
                                            active: index ==
                                                    controller
                                                        .curIndex.value
                                                ? true
                                                : false,
                                            text: controller
                                                .category[index].name,
                                          ),
                                        )
                                      : ListView.builder(
                                          padding:
                                              const EdgeInsets.all(0),
                                          scrollDirection:
                                              Axis.horizontal,
                                          itemCount:
                                              controller.category.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                      index) =>
                                                  TabButton(
                                            controller: controller,
                                            index: index,
                                            ontap: () {
                                              controller.curIndex.value =
                                                  index;
                                              controller.cIndex.value =
                                                  !controller
                                                      .cIndex.value;
                                              controller.getData(
                                                  id: controller
                                                      .category[index]
                                                      .id);
                                            },
                                            active: index ==
                                                    controller
                                                        .curIndex.value
                                                ? true
                                                : false,
                                            text: controller
                                                .category[index].name,
                                          ),
                                        )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => !controller.isInternet.value
                    ? Center(
                    child: TextButton(
                      child: "Tap to refresh".toLabel(),
                      onPressed: () => controller.reload(),
                    ),
                      )
                    : controller.loadData.value
                        ? ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, index) =>
                                const LodingCard())
                        : controller.articleList.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                child: "No Article!".toLabel())
                            : ListView.builder(
                                itemCount: controller.articleList.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 15),
                                  child: MyCard(
                                    date: controller.articleList[index].date
                                        .dateTimeFormatString(),
                                    ontap: () => Get.to(() => BlogDetails(
                                          title: controller
                                              .articleList[index].title,
                                          content: controller
                                              .articleList[index].content,
                                        )),
                                    title:
                                        controller.articleList[index].title,
                                    author:
                                        controller.articleList[index].writer,
                                    imageLink:
                                        controller.articleList[index].image,
                                    tag: controller.articleList[index].tag,
                                    views: controller.articleList[index].views
                                        .toString(),
                                    description:
                                        controller.articleList[index].slug,
                                  )
                                      .animate()
                                      .fadeIn(duration: 900.ms, delay: 100.ms)
                                      .shimmer(
                                          blendMode: BlendMode.srcOver,
                                          color: Colors.white12)
                                      .move(
                                          begin: const Offset(-16, 0),
                                          curve: Curves.easeOutQuad),
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
