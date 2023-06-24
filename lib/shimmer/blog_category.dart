import 'package:aceprex/services/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BlogCatShimmer extends StatelessWidget {
  final int count;
  final Widget widget;
  const BlogCatShimmer({super.key, required this.count, required this.widget});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
          baseColor: primaryLight,
          highlightColor: Colors.grey.shade300,
          enabled: true,
          child: widget),
    );
  }
}
