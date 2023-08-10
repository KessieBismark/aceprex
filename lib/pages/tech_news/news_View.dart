import 'package:aceprex/services/constants/constant.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:aceprex/services/widgets/glass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/shimmer_placeholders.dart';
import '../../services/widgets/waiting.dart';
import 'component/model.dart';
import 'news_details.dart';

class NewsView extends StatelessWidget {
  const NewsView({
    super.key,
    required this.data,
  });

  final List<TechModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, index) => Material(
        elevation: 10,
        child:
            // SizedBox(
            //   height: 300,
            //   child:
            InkWell(
          onTap: () {
            Get.to(
                () => NewDetails(
                      title: data[index].title,
                      content: data[index].content,
                    ),
                transition: Transition.fadeIn);
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Adjust opacity as desired
                    BlendMode.srcATop,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: fileUrl + data[index].image,
                    placeholder: (context, url) => const MWaiting(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Text(
                      data[index].date.dateTimeFormatString(),
                      style: TextStyle(color: light),
                    ).hPadding6),

                Positioned(
                  top: 140, // Adjust the position as desired
                  left: 0,
                  right: 0,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data[index].writer,
                        style: TextStyle(
                          color: lightGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Text(
                          maxLines: null,
                          overflow: TextOverflow.fade,
                          data[index].slug,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ).hPadding6.vPadding3,
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 900.ms, delay: 200.ms)
          .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
          .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
          .vPadding9,
      //  ),
    );
  }
}

class NewsViewShimmer extends StatelessWidget {
  const NewsViewShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, index) => SizedBox(
        height: 300,
        child: GlassContainer(
          width: double.infinity,
          height: 298,
          widget: Stack(
            alignment: Alignment.center,
            children: [
              // Background Image
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), // Adjust opacity as desired
                  BlendMode.srcATop,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: trans,
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(115, 158, 158, 158),
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: TitlePlaceholder(
                      width: myWidth(context, 2.5),
                    ).hPadding6,
                  )),

              Positioned(
                top: 220, // Adjust the position as desired
                left: 0,
                right: 0,

                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(115, 158, 158, 158),
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlePlaceholder(
                        width: double.infinity,
                      ),
                      TitlePlaceholder(
                        width: double.infinity,
                      ),
                      TitlePlaceholder(
                        width: double.infinity,
                      )
                    ],
                  ).hPadding6,
                ),
              ),
            ],
          ),
        ),
      ).vMargin9,
    );
  }
}
