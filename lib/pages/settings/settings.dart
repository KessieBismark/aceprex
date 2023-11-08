import 'package:aceprex/services/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/utils/themes.dart';
import '../../services/widgets/extension.dart';
import '../chats/image_viewer.dart';
import 'change_password.dart';
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
        backgroundColor: primaryColor,
        elevation: 0,
        title: "Settings".toLabel(color: light),
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
                                NetworkImage(fileUrl + Utils.userAvatar.value),
                          )
                        : Utils.isUrl(fileUrl + Utils.userAvatar.value)
                            ? InkWell(
                                onTap: () => Get.to(
                                  () => ImageViewer(
                                      imageUrl:
                                          fileUrl + Utils.userAvatar.value,
                                      tag: Utils.userName),
                                ),
                                child: CircleAvatar(
                                    maxRadius: 70,
                                    backgroundImage: NetworkImage(
                                        fileUrl + Utils.userAvatar.value)),
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
                  leading: const Icon(
                    Icons.lock,
                  ),
                  title: const Text("Change Password"),
                ),
                const Divider(),
                ListTile(
                  onTap: () => Utils.logOut(),
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sign Out"),
                ),
                const Divider(),
                ListTile(
                  onTap: () => deleteData(),
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: const Text("Delete Account"),
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
                ListTile(
                  onTap: () => controller.launchPUrl(),
                  leading: const Icon(Icons.file_open_outlined),
                  title: const Text("Privacy Policy"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteData() {
    return Get.defaultDialog(
      title: "Account Deletion",
      content: Form(
        key: controller.skey,
        child: Column(
          children: [
            const Text(
                "Deleting your account is a process that cannot be reversed. Are you sure you want to delete your account?"),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => MButton(
                    onTap: () => controller.deleteAccount(),
                    type: ButtonType.delete,
                    isLoading: controller.isSave.value,
                  ),
                ),
                MButton(
                  onTap: () => Get.back(),
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        ),
      ),
    );
  }
}
