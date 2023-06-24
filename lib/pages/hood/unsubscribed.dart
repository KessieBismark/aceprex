import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'component/controller.dart';
import 'widget/hero_widgt.dart';

class UnSubscribedDetails extends GetView<HoodController> {
  final String title;
  final int id;
  final String author;
  final String image;
  final String description;
  final String rating;
  final int? comment;
  final DateTime date;
  final int principal;
  const UnSubscribedDetails(
      {super.key,
      required this.title,
      required this.id,
      required this.author,
      required this.image,
      required this.description,
      required this.rating,
      required this.principal,
      required this.date,
      this.comment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: title.toLabel(),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: HeroWidget(
                    trans: true,
                    tag: id,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(0.3), // Adjust opacity as desired
                        BlendMode.srcATop,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: title.toLabel(bold: true, fontsize: 17)),
              Align(
                  alignment: Alignment.topLeft,
                  child: author.toLabel(bold: true, color: primaryLight)),
              Row(
                children: [
                  date.dateTimeFormatShortString().toLabel(color: lightGrey),
                  const Spacer(),
                  Tooltip(
                    message: double.parse(rating).toString(),
                    child: RatingBar.builder(
                      itemSize: 15,
                      initialRating: double.parse(rating),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(description),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MButton(
                  onTap: () => controller.subscribe(id, title, principal),
                  isLoading: controller.subBool.value,
                  title: "Subscribe",
                  icon: const Icon(
                    Icons.check,
                    size: 15,
                  ),
                  color: secondaryColor,
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ).padding9,
        ],
      ),
    );
  }
}
