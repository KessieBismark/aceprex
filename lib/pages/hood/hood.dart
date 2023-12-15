import 'package:aceprex/pages/hood/attachment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../init_widget/top_nav.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/widgets/extension.dart';
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
    return RefreshIndicator(
        onRefresh: () async {
          await controller.reload();
        },
        child: SafeArea(
          child: Scaffold(
            extendBody: true,
            body:
                // UpgradeAlert(
                //   upgrader: Upgrader(
                //     canDismissDialog: false,
                //     showIgnore: false,
                //     showLater: false,
                //     durationUntilAlertAgain: const Duration(days: 1),
                //     dialogStyle: Platform.isIOS
                //         ? UpgradeDialogStyle.cupertino
                //         : UpgradeDialogStyle.material,
                //   ),
                //   child:
                GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  TopBar(
                    title: "Research",
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
                  Obx(() => controller.loadSub.value
                      ? Container()
                      : controller.unSubscribedList.isNotEmpty
                          ? Align(
                                  alignment: Alignment.topLeft,
                                  child: "New Publication(s)"
                                      .toLabel(bold: true, fontsize: 17))
                              .padding9
                          : Container()),
                  Obx(() => controller.loadSub.value
                      ? SizedBox(
                          height: 126,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, index) =>
                                categoryItemShimmer(context).margin9,
                          ),
                        )
                      : !controller.isInternet.value
                          ? Container()
                          : controller.unSubscribedList.isNotEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 126,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        controller.unSubscribedList.length,
                                    itemBuilder:
                                        (BuildContext context, index) => Hero(
                                      transitionOnUserGestures: true,
                                      tag:
                                          controller.unSubscribedList[index].id,
                                      child: CategoryItem(
                                        subscribe: () => controller.subscribe(
                                          controller.unSubscribedList[index].id,
                                          controller
                                              .unSubscribedList[index].title,
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
                                                .unSubscribedList[index].date,
                                            title: controller
                                                .unSubscribedList[index].title,
                                            image: controller
                                                .unSubscribedList[index].image,
                                            author: controller
                                                .unSubscribedList[index].author,
                                            rating: controller
                                                .unSubscribedList[index].rate,
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
                                        image: fileUrl +
                                            controller
                                                .unSubscribedList[index].image,
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 900.ms, delay: 100.ms)
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
                    child: "Subscribed Publication(s)"
                        .toLabel(bold: true, fontsize: 17),
                  ).margin9,
                  Obx(
                    () => !controller.isInternet.value
                        ? Container(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: "Tap to refresh".toLabel(),
                              onPressed: () => controller.reload(),
                            ),
                          )
                        : controller.loadData.value
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.90,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                ),
                                itemCount: 4,
                                itemBuilder: (BuildContext context, index) =>
                                    const ShimmerSubscribed())
                            : controller.hoodList.isEmpty
                                ? const Center(
                                    child: Text('You have no subscription!'))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.90,
                                      crossAxisSpacing: 2.0,
                                      mainAxisSpacing: 2.0,
                                    ),
                                    itemCount: controller.hoodList.length,
                                    itemBuilder: (BuildContext context,
                                            index) =>
                                        Subscribed(
                                      ontap: () {
                                        controller.getSubscribed(
                                            controller.hoodList[index].id);
                                        Get.to(
                                            () => Attachments(
                                                  authorID: controller
                                                      .hoodList[index].authorID,
                                                  hood: controller
                                                      .hoodList[index].name,
                                                  hoodID: controller
                                                      .hoodList[index].id,
                                                ),
                                            transition: Transition.fadeIn);
                                      },
                                      title: controller.hoodList[index].name,
                                      image: fileUrl +
                                          controller.hoodList[index].image,
                                      author: controller.hoodList[index].author,
                                    )
                                            .animate()
                                            .fadeIn(
                                                duration: 900.ms, delay: 200.ms)
                                            .shimmer(
                                                blendMode: BlendMode.srcOver,
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
            ),
            //),
          ),
        ));

    //),
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
        style: TextStyle(color: light),
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

            Future.delayed(const Duration(microseconds: 300)).then(
              (value) {
                controller.hoodList = controller.hoodData.where(
                  (data) {
                    var title = data.name.toLowerCase();
                    var author = data.author.toLowerCase();
                    var date = data.date;

                    return title.contains(text.toLowerCase()) ||
                        author.contains(text.toLowerCase()) ||
                        date.toString().contains(text);
                  },
                ).toList();
              },
            );
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
                    color: light,
                  ),
                )
              : Icon(
                  Icons.search,
                  color: light,
                )),
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
            borderSide: BorderSide.none, // Remove the border edges
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // Remove the border edges
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Search',
          labelStyle: TextStyle(color: light),
        ),
      ),
    );
  }
}
