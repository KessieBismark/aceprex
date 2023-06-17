import 'services/constants/color.dart';
import 'services/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'intro_screens/intro_1.dart';
import 'intro_screens/intro_2.dart';
import 'intro_screens/intro_3.dart';
import 'intro_screens/intro_4.dart';

class OnBoardingScreen extends GetView<BoardController> {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              onPageChanged: (index) {
                controller.pageIndex.value = index;
              },
              controller: controller.pageController,
              children: const [
                IntroOne(),
                IntroTwo(),
                IntroThree(),
                IntroFour()
              ]),

          // dot indicator
          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => controller.pageIndex.value == 0
                      ? GestureDetector(
                          onTap: () =>
                              controller.pageController.animateToPage(3,
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.easeIn),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.skip_next, color: dark, size: 16),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => controller.pageController
                              .animateToPage(controller.pageIndex.value - 1,
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.easeIn),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.arrow_back_ios,
                                color: dark, size: 16),
                          ),
                        ),
                ),
                SmoothPageIndicator(
                  controller: controller.pageController,
                  count: 4,
                  effect:
                      ExpandingDotsEffect(activeDotColor: Colors.blue[100]!),
                  onDotClicked: (index) {
                    controller.pageController.animateToPage(index,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.easeIn);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.pageIndex.value != 3) {
                      controller.pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      Utils.setInto();
                      Get.offNamed('/start-up');
                    }
                  },
                  child: Obx(
                    () => controller.pageIndex.value == 3
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.done, color: dark, size: 16),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.arrow_forward_ios,
                                color: dark, size: 16),
                          ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BoardController extends GetxController {
  PageController pageController = PageController();
  var pageIndex = 0.obs;
}
