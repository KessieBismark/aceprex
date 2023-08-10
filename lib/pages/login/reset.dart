import 'package:aceprex/services/constants/color.dart';
import 'package:aceprex/services/constants/constant.dart';
import 'package:aceprex/services/widgets/button.dart';
import 'package:aceprex/services/widgets/extension.dart';
import 'package:aceprex/services/widgets/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'component/controller.dart';

class Reset extends GetView<LoginController> {
  const Reset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Reset Password".toLabel(),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: light,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: myWidth(context, 1.3),
                  child: Obx(
                    () => TextField(
                      readOnly: controller.ready.value,
                      controller: controller.email,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 35),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                Obx(() => controller.isSendEmail.value
                    ? const MWaiting()
                    : controller.ready.value
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              controller.sendReset();
                            },
                            icon: const Icon(Icons.forward)))
              ],
            ).margin9,
            Obx(
              () => controller.ready.value
                  ? Form(
                      key: controller.resetKey,
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: controller.resetCode,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.numbers,
                                  size: 20,
                                ),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 35),
                                suffixIconConstraints:
                                    BoxConstraints(minWidth: 35),
                                hintText: 'Reset code',
                                hintStyle: TextStyle(fontSize: 14)),
                          ).margin9,
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showPassword.value,
                            controller: controller.pass,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                prefixIconConstraints:
                                    const BoxConstraints(minWidth: 35),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.showPassword.value =
                                          !controller.showPassword.value;
                                    },
                                    icon: controller.showPassword.value
                                        ? const Icon(
                                            Icons.visibility_off,
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            size: 20,
                                          )),
                                suffixIconConstraints:
                                    const BoxConstraints(minWidth: 35),
                                hintText: 'New password',
                                hintStyle: const TextStyle(fontSize: 14)),
                          ).margin9,
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showPassword.value,
                            controller: controller.cpassword,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                prefixIconConstraints:
                                    const BoxConstraints(minWidth: 35),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.showPassword.value =
                                          !controller.showPassword.value;
                                    },
                                    icon: controller.showPassword.value
                                        ? const Icon(
                                            Icons.visibility_off,
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            size: 20,
                                          )),
                                suffixIconConstraints:
                                    const BoxConstraints(minWidth: 35),
                                hintText: 'Confirm password',
                                hintStyle: const TextStyle(fontSize: 14)),
                          ).margin9,
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MButton(
                                onTap: () {
                                  controller.resetPassword();
                                },
                                type: ButtonType.save,
                                isLoading: controller.isSaveReset.value,
                              ),
                              MButton(
                                onTap: () => Get.back(),
                                type: ButtonType.close,
                              )
                            ],
                          ).margin9
                        ],
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
