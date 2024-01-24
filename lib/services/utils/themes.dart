import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color.dart';
import 'helpers.dart';

class ThemeController extends GetxController {
  BuildContext? context;
  final _isLightTheme = false.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', _isLightTheme.value);
  }

  _getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;
    _isLightTheme.value = await isLight.value;
    Get.changeThemeMode(_isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  void onInit() {
    _getThemeStatus();
    super.onInit();
  }
}

class ThemeService {
  final _getStorage = GetStorage();
  final isDark = 'isDarkMode';

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    return _getStorage.read(isDark) ?? false;
  }

  saveThemeMode(bool isDarkMode) {
    _getStorage.write(isDark, isDarkMode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    Utils.themeDark.value = isSavedDarkMode();
    saveThemeMode(!isSavedDarkMode());
   
  }
}

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: dark), labelStyle: TextStyle(color: dark)),
    scaffoldBackgroundColor: mygrey,
    canvasColor: mygrey,

    textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: dark),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
    }),
  );

  final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: dark,

    textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: light),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
    }),
  );
}

ThemeData lightTheme = ThemeData.light().copyWith(
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: dark), labelStyle: TextStyle(color: dark)),
  scaffoldBackgroundColor: mygrey,
  canvasColor: mygrey,


  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: dark),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
  }),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: dark,


  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: light),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
  }),
);
