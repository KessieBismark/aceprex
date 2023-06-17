import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../init_widget/top_nav.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/glass.dart';
import '../../services/widgets/shimmer_placeholders.dart';
import 'component/controller.dart';
import 'file_view.dart';
import 'unsubscribed.dart';
import 'widget/category_item.dart';
import 'widget/shimmer_sub.dart';
import 'widget/subscribed.dart';

class Hood extends GetView<HoodController> {
  const Hood({super.key});

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
            child: Column(
              children: [
                TopBar(
                  title: "Hood",
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      searchTextField(context, myWidth(context, 1.1)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Obx(() => controller.loadSub.value
                          ? Container()
                          : controller.unSubscribedList.isNotEmpty
                              ? Align(
                                      alignment: Alignment.topLeft,
                                      child: "New Hood(s)"
                                          .toLabel(bold: true, fontsize: 17))
                                  .padding9
                              : Container()),
                      Obx(() => controller.loadSub.value
                          ? SizedBox(
                              height: 124,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (BuildContext context, index) =>
                                    categoryItemShimmer(context).margin9,
                              ))
                          : !controller.isInternet.value
                              ? Container()
                              : controller.unSubscribedList.isNotEmpty
                                  ? SizedBox(
                                      height: 124,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.unSubscribedList.length,
                                        itemBuilder:
                                            (BuildContext context, index) =>
                                                Hero(
                                          transitionOnUserGestures: true,
                                          tag: controller
                                              .unSubscribedList[index].id,
                                          child: CategoryItem(
                                            subscribe: () =>
                                                controller.subscribe(
                                              controller
                                                  .unSubscribedList[index].id,
                                              controller.unSubscribedList[index]
                                                  .title,
                                              controller.unSubscribedList[index]
                                                  .principal,
                                            ),
                                            onTap: () => Get.to(
                                              () => UnSubscribedDetails(
                                                id: controller
                                                    .unSubscribedList[index].id,
                                                comment: controller
                                                    .unSubscribedList[index]
                                                    .comment,
                                                date: controller
                                                    .unSubscribedList[index]
                                                    .date,
                                                title: controller
                                                    .unSubscribedList[index]
                                                    .title,
                                                image: controller
                                                    .unSubscribedList[index]
                                                    .image,
                                                author: controller
                                                    .unSubscribedList[index]
                                                    .author,
                                                rating: controller
                                                    .unSubscribedList[index]
                                                    .rate,
                                                description: controller
                                                    .unSubscribedList[index]
                                                    .description,
                                                principal: controller
                                                    .unSubscribedList[index]
                                                    .principal,
                                              ),
                                              //transition: Transition.fadeIn
                                            ),
                                            title: controller
                                                .unSubscribedList[index].title,
                                            author: controller
                                                .unSubscribedList[index].author,
                                            rate: controller
                                                .unSubscribedList[index].rate,
                                            image: controller
                                                .unSubscribedList[index].image,
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 900.ms,
                                                  delay: 100.ms)
                                              .shimmer(
                                                  blendMode: BlendMode.srcOver,
                                                  color: Colors.white12)
                                              .move(
                                                  begin: const Offset(-16, 0),
                                                  curve: Curves.easeOutQuad)
                                              .margin9,
                                        ),
                                      ),
                                    )
                                  : Container()),
                      Align(
                        alignment: Alignment.topLeft,
                        child: "Subscribed Hood(s)"
                            .toLabel(bold: true, fontsize: 17),
                      ).margin9,
                      Obx(
                        () => !controller.isInternet.value
                            ? Expanded(
                                child: Center(
                                child: TextButton(
                                  child: "Tap to refresh".toLabel(),
                                  onPressed: () => controller.reload(),
                                ),
                              ),)
                            : controller.loadData.value
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.1,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 20.0,
                                    ),
                                    itemCount: 6,
                                    itemBuilder:
                                        (BuildContext context, index) =>
                                            const ShimmerSubscribed())
                                : controller.subscribedList.isEmpty
                                    ? const Center(
                                        child:
                                            Text('You have no subscription!'))
                                    : GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.95,
                                          crossAxisSpacing: 2.0,
                                          mainAxisSpacing: 2.0,
                                        ),
                                        itemCount:
                                            controller.subscribedList.length,
                                        itemBuilder: (BuildContext context,
                                                index) =>
                                            Subscribed(
                                          ontap: () {
                                            controller.checkSaved(controller
                                                .subscribedList[index].id
                                                .toString());
                                            controller.getLikesDislike(
                                                controller
                                                    .subscribedList[index].id);
                                            controller.read(controller
                                                .subscribedList[index].id);
                                            if (controller.subscribedList[index]
                                                .fileLink.isNotEmpty) {
                                              Get.to(() => SubscribedView(
                                                    principal: controller
                                                        .subscribedList[index]
                                                        .principal,
                                                    title: controller
                                                        .subscribedList[index]
                                                        .title,
                                                    fileLink: controller
                                                        .subscribedList[index]
                                                        .fileLink,
                                                    likes: controller
                                                        .subscribedList[index]
                                                        .likes,
                                                    dislike: controller
                                                        .subscribedList[index]
                                                        .disLike,
                                                    comment: controller
                                                        .subscribedList[index]
                                                        .comment,
                                                    id: controller
                                                        .subscribedList[index]
                                                        .id,
                                                    author: controller
                                                        .subscribedList[index]
                                                        .author,
                                                    fileID: controller
                                                        .subscribedList[index]
                                                        .fileID,
                                                    imagPath: controller
                                                        .subscribedList[index]
                                                        .image,
                                                    pdfPath: controller
                                                        .subscribedList[index]
                                                        .fileLink,
                                                    description: controller
                                                        .subscribedList[index]
                                                        .describtion,
                                                  ));
                                            } else {
                                              Utils().showError(
                                                  "File link is incorrect");
                                            }
                                          },
                                          title: controller
                                              .subscribedList[index].title,
                                          image: controller
                                              .subscribedList[index].image,
                                          author: controller
                                              .subscribedList[index].author,
                                        )
                                                .animate()
                                                .fadeIn(
                                                    duration: 900.ms,
                                                    delay: 200.ms)
                                                .shimmer(
                                                    blendMode:
                                                        BlendMode.srcOver,
                                                    color: Colors.white12)
                                                .move(
                                                    begin: const Offset(-16, 0),
                                                    curve: Curves.easeOutQuad)
                                                .padding9,
                                      ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        //),
      ),
    );
  }

  SizedBox categoryItemShimmer(BuildContext context) {
    return SizedBox(
      height: 120,
      width: myWidth(context, 2),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(25),
        child: GlassContainer(
          widget: Shimmer.fromColors(
            baseColor: const Color.fromARGB(115, 158, 158, 158),
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    height: myHeight(context, 8),
                    width: myWidth(context, 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ).padding6.hMargin3,
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        TitlePlaceholder(
                          width: double.infinity,
                        ),
                        TitlePlaceholder(
                          width: double.infinity,
                        ),
                        TitlePlaceholder(
                          width: double.infinity,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          width: 230,
          height: 120,
        ),
      ),
    );
  }

  SizedBox searchTextField(BuildContext context, width) {
    final controller = Get.find<HoodController>();
    return SizedBox(
      width: width,
      height: 40,
      child: TextField(
        style: TextStyle(color: dark),
        controller: controller.searchController,
        onChanged: (text) {
          if (text.isNotEmpty) {
            controller.isSearching.value = true;
            controller.loadSub.value = true;
            controller.loadData.value = true;

            Future.delayed(const Duration(microseconds: 300)).then((value) {
              controller.unSubscribedList =
                  controller.unSubscribed.where((data) {
                var title = data.title.toLowerCase();
                var author = data.author.toLowerCase();
                var date = data.date;

                return title.contains(text.toLowerCase()) ||
                    author.contains(text.toLowerCase()) ||
                    date.toString().contains(text);
              }).toList();
            });

            Future.delayed(const Duration(microseconds: 300)).then((value) {
              controller.subscribedList = controller.subscribed.where((data) {
                var title = data.title.toLowerCase();
                var author = data.author.toLowerCase();
                var date = data.date;

                return title.contains(text.toLowerCase()) ||
                    author.contains(text.toLowerCase()) ||
                    date.toString().contains(text);
              }).toList();
            });
            controller.loadSub.value = false;
            controller.loadData.value = false;
          } else {
            controller.unSubscribedList = controller.unSubscribed;
            controller.subscribedList = controller.subscribed;
            controller.loadData.value = true;
            controller.loadSub.value = true;
            controller.isSearching.value = false;
            controller.loadSub.value = false;
            controller.loadData.value = false;
          }
        },
        decoration: InputDecoration(
          suffixIcon: Obx(() => controller.isSearching.value
              ? IconButton(
                  onPressed: () {
                    controller.unSubscribedList = controller.unSubscribed;
                    controller.subscribedList = controller.subscribed;
                    controller.loadData.value = true;
                    controller.loadSub.value = true;
                    controller.searchController.clear();
                    controller.isSearching.value = false;

                    controller.isSearching.value = false;
                    controller.loadSub.value = false;
                    controller.loadData.value = false;
                  },
                  icon: Icon(
                    Icons.clear,
                    color: grey,
                  ),
                )
              : Icon(
                  Icons.search,
                  color: grey,
                )),
          filled: true,
          fillColor: Colors.blue[100],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          hintText: 'Enter any keyword',
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // Remove the border edges
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // Remove the border edges
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // Remove the border edges
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Search',
          labelStyle: TextStyle(color: grey),
        ),
      ),
    );
  }
}
