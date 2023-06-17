import '../../home_page/home.dart';
import '../../pages/login/component/binding.dart';
import '../../pages/login/login.dart';
import 'binding.dart';
import '../../signup/component/binding.dart';
import '../../signup/signup.dart';
import '../../splash/splash_screen.dart';
import 'package:get/get.dart';

import '../../onboarding_screen.dart';
import '../../pages/startup/startup.dart';

class Routes {
  static final routes = [
    GetPage(
      transition: Transition.fadeIn,
      name: '/auth',
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: '/signup',
      page: () => const SignUpPage(),
      binding: SBindings(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: '/dash',
      page: () => const Home(),
      binding: AllBindings(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: '/splash',
      page: () => const SplashScreen(),
      binding: AllBindings(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: '/intro',
      page: () => const OnBoardingScreen(),
      binding: AllBindings(),
    ),
      GetPage(
        transition: Transition.fadeIn,
      name: '/start-up',
      page: () => const StartUp(),
      binding: AllBindings(),
    ),
  ];
}
