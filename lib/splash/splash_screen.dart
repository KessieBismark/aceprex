import 'dart:convert';

import '../onboarding_screen.dart';
import '../services/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../services/constants/color.dart';
import '../services/utils/helpers.dart';
import '../services/utils/query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((status) {
      if (!status) {
        Utils.getLogin().then((result) {
          if (result) {
            // FlutterBackgroundService().invoke('setAsForeground');
            //  Get.to(() => const Home(), transition: Transition.fadeIn);
            Get.toNamed('/dash');
          } else {
            //Get.to(const StartUp(), transition: Transition.fadeIn);
            Get.toNamed('/start-up');
          }
        });
      } else {
        Get.to(const OnBoardingScreen(), transition: Transition.fadeIn);
      }
    });
  }

  Future<void> setOnline(int status) async {
    try {
      var query = {
        "action": "set_online",
        "status": status.toString(),
        "userID": Utils.userID,
      };
      var response = await Query.queryData(query);
      if (jsonDecode(response) == 'false') {
        // Handle error case
      } else {
        // Handle success case
      }
    } catch (e) {
      // Handle error case
    }
  }

  Future<bool> _mockCheckForSession() async {
    bool result = false;
    await Future.delayed(const Duration(milliseconds: 3000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("intro")) {
        result = prefs.getBool("intro")!;
      }

      return result;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Shimmer.fromColors(
            period: const Duration(milliseconds: 1500),
            baseColor: primaryColor, //const Color(0xff7f00ff),
            highlightColor: light, //const Color(0xffe100ff),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "AcePrex",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 6.5,
                    // fontSize: 90.0,
                    fontFamily: poppinsBold,
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: 18.0,
                        color: Colors.black87,
                        offset: Offset.fromDirection(120, 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
