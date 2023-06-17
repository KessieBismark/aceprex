import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../services/constants/constant.dart';
import '../services/widgets/extension.dart';
import 'clipper.dart';

class IntroFour extends StatelessWidget {
  const IntroFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                  color: Colors.blue[50],
                  height: myHeight(context, 2),
                  child: Center(
                    child: Lottie.asset(
                      "assets/animi/113537-brainstorming.json",
                      width: myWidth(context, 1.3),
                      height: myHeight(context, 2.9),
                      fit: BoxFit.fill,
                    ),
                  )),
            ).animate().scale(delay: 300.ms, duration: 300.ms),
            const SizedBox(
              height: 10,
            ),
            "Engage in Discussions"
                .toAutoLabel(bold: true, fontsize: 25)
                .animate()
                .scale(delay: 400.ms, duration: 300.ms)
                .hPadding9
                .vMargin3,
            const Text(
              "Connect with a vibrant community of students and researchers to engage in thought-provoking discussions.",
              style: TextStyle(fontSize: 15),
            )
                .hPadding9
                .animate()
                .fadeIn(delay: 700.ms, duration: 300.ms)
                .slide(delay: 700.ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
