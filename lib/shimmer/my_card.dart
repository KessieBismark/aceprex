import 'package:aceprex/services/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../services/constants/constant.dart';
import '../services/widgets/glass.dart';
import '../services/widgets/shimmer_placeholders.dart';

class ShimerMyCard extends StatelessWidget {
  const ShimerMyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 203,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(25),
              child: GlassContainer(
                widget: Shimmer.fromColors(
                  baseColor:lightGrey,
                  highlightColor: Colors.grey.shade300,
                  enabled: true,
                  child: Column(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BannerPlaceholder(
                          height: 100,
                          width: myWidth(context, 2.8),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TitlePlaceholder(width: myWidth(context, 2.8)),
                              TitlePlaceholder(width: myWidth(context, 3.2)),
                              const SizedBox(
                                height: 5,
                              ),
                              const TitlePlaceholder(
                                width: double.infinity,
                              ),
                              const TitlePlaceholder(
                                width: double.infinity,
                              ),
                              const TitlePlaceholder(
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const TitlePlaceholder(
                      width: double.infinity,
                    ),
                  ]),
                ),
                width: myWidth(
                  context,
                  1.02,
                ),
                height: 190,
              ),
            ),
          ),
          Positioned(
            left: 30,
            child: Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: Colors.grey.shade300,
              enabled: true,
              child: Container(
                  height: 25,
                  width: myWidth(context, 2.3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(" ")),
            ),
          ),
        ],
      ),
    );
  }
}

class LodingCard extends StatelessWidget {
  const LodingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 20,
          ),
          ShimerMyCard(),
          SizedBox(
            height: 20,
          ),
          ShimerMyCard(),
          SizedBox(
            height: 20,
          ),
          ShimerMyCard(),
          SizedBox(
            height: 20,
          ),
          ShimerMyCard(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
