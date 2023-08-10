import '../services/utils/themes.dart';
import '../services/widgets/extension.dart';
import '../services/widgets/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../services/constants/color.dart';
import '../services/utils/helpers.dart';
import 'component/controller.dart';

class SignUpPage extends GetView<SController> {
  const SignUpPage({Key? key}) : super(key: key);

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
                height: 200,
                decoration: const BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(900),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 500,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          child: GlassmorphicContainer(
                            width: 350,
                            height: 570,
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
                                const Color(0xFFC0C0C0).withOpacity(0.05)
                              ],
                            ),
                            child: Form(
                              key: controller.signUpKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(15).copyWith(top: 70),
                                child: ListView(
                                  children: [
                                    TextField(
                                      controller: controller.username,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            size: 20,
                                          ),
                                          prefixIconConstraints:
                                              BoxConstraints(minWidth: 35),
                                          hintText: 'Display Name',
                                          hintStyle: TextStyle(fontSize: 14)),
                                    ),
                                    const SizedBox(height: 15),
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
                                    TextField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      controller: controller.pass,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeService()
                                                          .isSavedDarkMode()
                                                      ? Colors.white70
                                                      : dark)),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            size: 20,
                                          ),
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                                  minWidth: 35),
                                          suffixIconConstraints:
                                              const BoxConstraints(
                                                  minWidth: 35),
                                          hintText: 'Enter your password',
                                          hintStyle:
                                              const TextStyle(fontSize: 14)),
                                    ),
                                    const SizedBox(height: 15),
                                    TextField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      controller: controller.cPass,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            size: 20,
                                          ),
                                          prefixIconConstraints:
                                              BoxConstraints(minWidth: 35),
                                          suffixIconConstraints:
                                              BoxConstraints(minWidth: 35),
                                          hintText: 'Confirm password',
                                          hintStyle: TextStyle(fontSize: 14)),
                                    ),
                                    const SizedBox(height: 15),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Obx(() => controller.loading.value
                                        ? const MWaiting()
                                        : ElevatedButton(
                                            onPressed: () {
                                              if (GetUtils.isEmail(
                                                  controller.email.text)) {
                                                controller.signUP();
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
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 100,
                                                          vertical: 20)),
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
                                            child: "Sign up".toLabel(),
                                          )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Already have account? ',
                                          style: TextStyle(
                                              color: ThemeService()
                                                      .isSavedDarkMode()
                                                  ? Colors.white60
                                                  : dark,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () => Get.offAllNamed('/auth'),
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: primaryLight,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
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
