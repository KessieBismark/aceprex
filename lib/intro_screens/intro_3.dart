import 'package:aceprex/services/constants/color.dart';

import '../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../services/constants/constant.dart';
import 'clipper.dart';

class IntroThree extends StatelessWidget {
  const IntroThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        leading: Container(),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
                color: primaryColor,
                height: myHeight(context, 2),
                child: Center(
                  child: Lottie.asset(
                    "assets/animi/connect-globe.json",
                    width: myWidth(context, 1.3),
                    height: myHeight(context, 2.5),
                    fit: BoxFit.fill,
                  ),
                )),
          ).animate().scale(delay: 300.ms, duration: 300.ms),
          const SizedBox(
            height: 10,
          ),
          "Connect and Collaborate"
              .toAutoLabel(bold: true, fontsize: 25, color: primaryLight)
              .animate()
              .scale(delay: 400.ms, duration: 300.ms)
              .hPadding9
              .vMargin3,
          const Text(
            "Connect with fellow researchers, students, and experts in the field. Collaborate on projects, exchange knowledge, and foster meaningful connections that can shape the future of technology.",
            style: TextStyle(fontSize: 15),
          )
              .hPadding9
              .animate()
              .fadeIn(delay: 700.ms, duration: 300.ms)
              .slide(delay: 700.ms, duration: 300.ms),
        ],
      ),
    );
  }
}
