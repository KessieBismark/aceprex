import '../pages/settings/settings.dart';
import '../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/constants/color.dart';
import '../services/utils/helpers.dart';

class TopBar extends StatelessWidget {
  final String title;
  final Widget widget;
  const TopBar({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),

        ///  bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.blue[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utils.isUrl(Utils.userAvatar.value)
                    ? CircleAvatar(
                        maxRadius: 20,
                        backgroundImage: NetworkImage(Utils.userAvatar.value))
                    : const CircleAvatar(
                        maxRadius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                title.toLabel(bold: true, color: dark),

                IconButton(
                  onPressed: () => Get.to(() => const Settings()),
                  icon: Icon(
                    Icons.settings,
                    color: dark,
                  ),
                )

              ],
            ).hPadding9.padding9.padding3,
            const SizedBox(
              height: 10,
            ),
            widget
          ],
        ),
      ),
    );
  }
}
