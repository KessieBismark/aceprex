// ignore_for_file: must_be_immutable

import 'package:aceprex/services/constants/color.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ClearText extends StatelessWidget {
  List<String> textList = <String>[];
  final int initialPage;
  final String title;
  final TtsController ttsController = Get.put(TtsController());

  ClearText({
    Key? key,
    required this.textList,
    required this.title,
    required this.initialPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: title.toAutoLabel(),
          actions: [
            Obx(() => Slider(
                  value: ttsController.fontSize.value,
                  min: 10.0, // Minimum font size
                  max: 40.0, // Maximum font size
                  onChanged: (value) {
                    ttsController.setFontSize(value);
                  },
                )),
          ],
        ),
        body: Obx(() => ttsController.fontChanged.value
            ? displaySeciton()
            : displaySeciton()));
  }

  ListView displaySeciton() {
    return ListView.builder(
      itemCount: textList.length - initialPage,
      itemBuilder: (context, index) {
        final adjustedIndex = index + initialPage;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    "Page $adjustedIndex".toAutoLabel(),
                    IconButton(
                      onPressed: () {
                        if (ttsController.isPlaying.value) {
                          ttsController.stop();
                        } else {
                          ttsController.readAloud(adjustedIndex, textList);
                        }
                      },
                      icon: Obx(() => ttsController.isPlaying.value &&
                              ttsController.playIndex.value == adjustedIndex
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                    ).hPadding9.hPadding9,
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SelectableText(
                    ttsController
                        .combineTextParagraphs(textList[adjustedIndex]),
                    style: TextStyle(
                      fontSize: ttsController.fontSize.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
