import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/color.dart';

class ShimmerCard extends StatelessWidget {
  final double height;
  final double width;
  final Widget widget;

  const ShimmerCard(
      {Key? key,
      required this.height,
      required this.width,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: mygrey,
        child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 6),
                      color: lightGrey.withOpacity(.1),
                      blurRadius: 12)
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Expanded(child: widget)),
      ),
    );
  }
}

class LoadShimmer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const LoadShimmer({super.key, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: dark,
            child: child));
  }
}
