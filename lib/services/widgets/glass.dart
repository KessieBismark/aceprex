import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../utils/themes.dart';

class GlassFlex extends StatelessWidget {
  final Widget widget;
  const GlassFlex({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicFlexContainer(
      borderRadius: 2,
      blur: 20,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: widget,
    );
  }
}

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;
  final Widget widget;
  const GlassContainer(
      {super.key,
      required this.width,
      required this.height,
      this.borderRadius = 5,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius!,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 0,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ThemeService().isSavedDarkMode()
              ? [
                  const Color(0xFFC0C0C0).withOpacity(0.1),
                  const Color(0xFFC0C0C0).withOpacity(0.05),
                ]
              : [
                  const Color(0xFFC0C0C0).withOpacity(0.1),
                  const Color(0xFFC0C0C0).withOpacity(0.05),
                ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: ThemeService().isSavedDarkMode()
            ? [
                const Color(0xFFC0C0C0).withOpacity(0.5),
                const Color((0xFFC0C0C0)).withOpacity(0.5),
              ]
            : [
                const Color(0xFFC0C0C0).withOpacity(0.5),
                const Color((0xFFC0C0C0)).withOpacity(0.5),
              ],
      ),
      // margin: EdgeInsets.zero, // Ensure no margin
      // padding: EdgeInsets.zero, // Ensure no padding
      child: widget,
    );
  }
}
