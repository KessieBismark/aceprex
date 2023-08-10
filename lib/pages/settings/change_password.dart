import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/textbox.dart';
import 'component/controller.dart';

class ChangePassword extends GetView<SettingsController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: 'Change Password'.toLabel(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            Form(
                key: controller.skey,
                child: Column(
                  children: [
                    MEdit(
                      hint: "Enter current password",
                      password: true,
                      controller: controller.currentP,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Enter new password",
                      password: true,
                      controller: controller.newP,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Confirm new password",
                      password: true,
                      controller: controller.cP,
                      validate: Utils.validator,
                    ).padding9,
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => MButton(
                              onTap: () => controller.changePassword(),
                              type: ButtonType.save,
                              isLoading: controller.isSave.value,
                            )),
                        MButton(
                          onTap: () => Get.back(),
                          type: ButtonType.cancel,
                        )
                      ],
                    ).padding9
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
