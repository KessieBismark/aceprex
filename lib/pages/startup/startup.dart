import 'package:aceprex/pages/tech_news/component/controller.dart';

import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../init_widget/my_card.dart';
import '../../services/constants/color.dart';
import '../../shimmer/my_card.dart';
import '../blog/blog_details.dart';
import '../blog/component/controller.dart';
import '../tech_news/news_view.dart';

final techCon = Get.put(TechNewsController());

class StartUp extends GetView<ArticleController> {
  const StartUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        toolbarHeight: 0,
        elevation: 0,
        leading: Container(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.reload();
          await techCon.reload();
        },
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  color: primaryColor,
                  child: TopBarStartUP(
                    title: "Informative Publications",
                    widget: Column(
                      children: [
                        TabBar(
                          indicatorWeight: 5,
                          indicatorColor: primaryLight,
                          tabs: [
                            Tab(
                              child: "24".toLabel(
                                color: light,
                              ),
                            ),
                            Tab(
                              child: "Now & Next".toLabel(
                                color: light,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          techCon.getData();
                        },
                        child: Obx(() => !techCon.isInternet.value
                            ? Center(
                                child: TextButton(
                                  child: "No record found! Tap to refresh"
                                      .toLabel(),
                                  onPressed: () => techCon.reload(),
                                ),
                              )
                            : techCon.loadData.value
                                ? const NewsViewShimmer()
                                : NewsView(data: techCon.techNewsList))),
                    RefreshIndicator(
                        onRefresh: () async {
                          controller.getData();
                        },
                        child: Obx(
                          () => controller.loadData.value
                              ? ListView.builder(
                                  itemCount: 6,
                                  itemBuilder: (context, index) =>
                                      const LodingCard())
                              : controller.articleList.isEmpty
                                  ? Center(
                                      child: TextButton(
                                        child: "No record found! Tap to refresh"
                                            .toLabel(),
                                        onPressed: () => controller.getData(),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: controller.articleList.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 15),
                                        child: MyCard(
                                          date: controller
                                              .articleList[index].date
                                              .dateTimeFormatString(),
                                          ontap: () => Get.to(() => BlogDetails(
                                                title: controller
                                                    .articleList[index].title,
                                                content: controller
                                                    .articleList[index].content,
                                              )),
                                          title: controller
                                              .articleList[index].title,
                                          author: controller
                                              .articleList[index].writer,
                                          imageLink: controller
                                              .articleList[index].image,
                                          tag:
                                              controller.articleList[index].tag,
                                          views: controller
                                              .articleList[index].views
                                              .toString(),
                                          description: controller
                                              .articleList[index].slug,
                                        )
                                            .animate()
                                            .fadeIn(
                                                duration: 900.ms, delay: 100.ms)
                                            .shimmer(
                                                blendMode: BlendMode.srcOver,
                                                color: Colors.white12)
                                            .move(
                                                begin: const Offset(-16, 0),
                                                curve: Curves.easeOutQuad),
                                      ),
                                    ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBarStartUP extends StatelessWidget {
  final String title;
  final Widget widget;
  const TopBarStartUP({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),

        ///  bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: primaryColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Utils.isUrl(Utils.userAvatar.value)
                //     ? CircleAvatar(
                //         maxRadius: 20,
                //         backgroundImage: NetworkImage(Utils.userAvatar.value))
                //     : const CircleAvatar(
                //         maxRadius: 20,
                //         backgroundImage:
                //             AssetImage('assets/images/profile.png'),
                //       ),
                title.toLabel(bold: true, color: light),

                InkWell(
                    onTap: () => Get.toNamed('/auth'),
                    child: Row(
                      children: [
                        Icon(
                          Icons.login,
                          color: light,
                          size: 16,
                        ).hMargin6,
                        "Login".toLabel(bold: true, color: light),
                      ],
                    )),

                // IconButton(
                //   onPressed: () => Get.to(() => const Settings()),
                //   icon: Icon(
                //     Icons.settings,
                //     color: dark,
                //   ),
                // )
              ],
            ).hPadding9.padding9.padding3,
            const SizedBox(
              height: 10,
            ),
            widget
          ],
        ),
      ),
    );
  }
}
