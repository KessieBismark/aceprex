import 'package:aceprex/pages/login/reset.dart';

import '../../services/utils/helpers.dart';
import '../../services/utils/themes.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../services/constants/color.dart';
import 'component/controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: ThemeService().isSavedDarkMode() ? dark : light,
          child: Stack(
            children: [
              Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: primaryLight,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(900))),
              ),
              Center(
                child: SizedBox(
                  height: 430,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GlassmorphicContainer(
                          width: 350,
                          height: 400,
                          borderRadius: 20,
                          blur: 5,
                          alignment: Alignment.bottomCenter,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFC0C0C0).withOpacity(0.01),
                              const Color(0xFFC0C0C0).withOpacity(0.05)
                            ],
                          ),
                          borderGradient: LinearGradient(
                            colors: [
                              const Color(0xFFC0C0C0).withOpacity(0.01),
                              const Color(0xFFC0C0C0).withOpacity(0.05),
                            ],
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(15).copyWith(top: 70),
                              child: ListView(
                                children: [
                                  TextField(
                                    controller: controller.email,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          size: 20,
                                        ),
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 35),
                                        hintText: 'Enter your email',
                                        hintStyle: TextStyle(fontSize: 14)),
                                  ),
                                  const SizedBox(height: 15),
                                  Obx(() => TextField(
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText:
                                            !controller.showPassword.value,
                                        controller: controller.pass,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              size: 20,
                                            ),
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                                    minWidth: 35),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  controller
                                                          .showPassword.value =
                                                      !controller
                                                          .showPassword.value;
                                                },
                                                icon: controller
                                                        .showPassword.value
                                                    ? const Icon(
                                                        Icons.visibility_off,
                                                        size: 20,
                                                      )
                                                    : const Icon(
                                                        Icons.visibility,
                                                        size: 20,
                                                      )),
                                            suffixIconConstraints:
                                                const BoxConstraints(
                                                    minWidth: 35),
                                            hintText: 'Enter your password',
                                            hintStyle:
                                                const TextStyle(fontSize: 14)),
                                      )),
                                  const SizedBox(height: 15),
                                  InkWell(
                                    onTap: () {
                                      controller.clearData();
                                      Get.to(() => const Reset());
                                    },
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: primaryLight,
                                            // ThemeService().isSavedDarkMode()
                                            //     ? Colors.white.withOpacity(.8)
                                            //     : dark,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Obx(() => controller.loading.value
                                      ? const MWaiting()
                                      : ElevatedButton(
                                          onPressed: () {
                                            if (controller.email.text.isEmpty ||
                                                controller.pass.text.isEmpty) {
                                              Utils().showError(
                                                  "Email and password are required");
                                              return;
                                            }
                                            if (GetUtils.isEmail(
                                                controller.email.text)) {
                                              controller.login();
                                            } else {
                                              Utils().showError(
                                                  "Please enter a correct email");
                                            }
                                          },
                                          style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(2),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryLight),
                                            // ThemeService().isSavedDarkMode()
                                            //     ? MaterialStateProperty.all(trans)
                                            //     : MaterialStateProperty.all(blue),
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 100,
                                                  vertical: 20),
                                            ),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                              color: Colors.black,
                                            )),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            )),
                                          ),
                                          child: "Sign in".toLabel(),
                                        )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'New here? ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ThemeService()
                                                        .isSavedDarkMode()
                                                    ? Colors.white60
                                                    : dark,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                Get.offAllNamed('/signup'),
                                            child: const Text(
                                              'Sign up',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: primaryLight,
                                                  // ThemeService().isSavedDarkMode()
                                                  //     ? Colors.white.withOpacity(.8)
                                                  //     : blue,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () =>
                                              Get.offAllNamed('/start-up'),
                                          child: "Back"
                                              .toLabel(color: primaryLight))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/icons/logo.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
