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
            baseColor: const Color.fromARGB(193, 158, 158, 158),
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: widget));
  }
}
