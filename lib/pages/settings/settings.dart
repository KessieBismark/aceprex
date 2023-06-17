import 'change_password.dart';
import '../../services/constants/color.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/utils/themes.dart';
import '../chats/image_viewer.dart';
import 'component/controller.dart';

class Settings extends GetView<SettingsController> {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        elevation: 0,
        title: "Settings".toLabel(color: dark),
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
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => controller.imgSet.value
                        ? CircleAvatar(
                            maxRadius: 70,
                            backgroundImage:
                                AssetImage(Utils.userAvatar.value))
                        : Utils.isUrl(Utils.userAvatar.value)
                            ?  InkWell(
                                      onTap: () => Get.to(() => ImageViewer(
                                          imageUrl: Utils.userAvatar.value,
                                          tag: Utils.userName)),
                                      child: CircleAvatar(
                                  maxRadius: 70,
                                  backgroundImage: NetworkImage(Utils.userAvatar.value)),
                            )
                            : const CircleAvatar(
                                maxRadius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/profile.png'),
                              ),
                  ),
                ),
                Center(child: Utils.userName.toLabel()),
                Center(child: Utils.userEmail.toLabel()),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        controller.handleImageSelection();
                      },
                      child: "Set Profile".toLabel()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Account", style: headingStyle),
                  ],
                ),
                ListTile(
                  onTap: () {
                    controller.clearData();
                    Get.to(() => const ChangePassword());
                  },
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                ),
                const Divider(),
                ListTile(
                  onTap: () => Utils.logOut(),
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sign Out"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("App UI", style: headingStyle),
                  ],
                ),
                Obx(
                  () => Utils.themeDark.value
                      ? ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text("Change Theme"),
                          trailing: Switch(
                              value: ThemeService().isSavedDarkMode(),
                              activeColor: Colors.redAccent,
                              onChanged: (val) {
                                ThemeService().changeThemeMode();
                              }),
                        )
                      : ListTile(
                          leading: const Icon(Icons.light_mode),
                          title: const Text("Change Theme"),
                          trailing: Switch(
                            value: ThemeService().isSavedDarkMode(),
                            activeColor: Colors.redAccent,
                            onChanged: (val) {
                              ThemeService().changeThemeMode();
                            },
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Misc", style: headingStyle),
                  ],
                ),
                const ListTile(
                  leading: Icon(Icons.file_open_outlined),
                  title: Text("Terms of Service"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // changePassword() {
  //   return Get.defaultDialog(
  //     title: "Change Password",
  //     content: Form(
  //       key: controller.skey,
  //       child: Column(
  //         children: [
  //           MEdit(
  //             hint: "Enter current password",
  //             password: true,
  //             controller: controller.currentP,
  //             validate: Utils.validator,
  //           ).padding9,
  //           MEdit(
  //             hint: "Enter new password",
  //             password: true,
  //             controller: controller.newP,
  //             validate: Utils.validator,
  //           ).padding9,
  //           MEdit(
  //             hint: "Confirm new password",
  //             password: true,
  //             controller: controller.cP,
  //             validate: Utils.validator,
  //           ).padding9,
  //           const Divider(),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Obx(
  //                 () => MButton(
  //                   onTap: () => controller.changePassword(),
  //                   type: ButtonType.save,
  //                   isLoading: controller.isSave.value,
  //                 ),
  //               ),
  //               MButton(
  //                 onTap: () => Get.back(),
  //                 type: ButtonType.cancel,
  //               )
  //             ],
  //           ).padding9
  //         ],
  //       ),
  //     ),
  //   );
  //}
}
