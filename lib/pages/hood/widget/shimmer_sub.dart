import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/constants/constant.dart';
import '../../../services/widgets/glass.dart';
import '../../../services/widgets/shimmer_placeholders.dart';

class ShimmerSubscribed extends StatelessWidget {
  const ShimmerSubscribed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5),
      child: GlassContainer(
        borderRadius: 5,
        widget: Shimmer.fromColors(
          baseColor: const Color.fromARGB(115, 158, 158, 158),
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: myHeight(context, 7),
                width: myWidth(context, 2.5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
              ).padding6.hMargin3,
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    TitlePlaceholder(
                      width: double.infinity,
                    ),
                    TitlePlaceholder(
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        width: myWidth(
          context,
          2,
        ),
        height: 150,
      ),
    );
  }
}
