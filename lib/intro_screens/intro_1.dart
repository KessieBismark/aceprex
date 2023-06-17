import '../services/constants/constant.dart';
import '../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'clipper.dart';

class IntroOne extends StatelessWidget {
  const IntroOne({super.key});

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
                      "assets/animi/analysis.json",
                      width: myWidth(context, 1.3),
                      height: myHeight(context, 2.5),
                      fit: BoxFit.fill,
                    ),
                  )),
            ).animate().scale(delay: 300.ms, duration: 300.ms),
            const SizedBox(
              height: 10,
            ),
            "Explore Research Works"
                .toAutoLabel(bold: true, fontsize: 25)
                .animate()
                .scale(delay: 400.ms, duration: 300.ms)
                .hPadding9
                .vPadding3,
            const Text(
              "Dive into a vast collection of research works, spanning various disciplines and cutting-edge technologies.",
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
