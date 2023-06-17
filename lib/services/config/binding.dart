import '../../home_page/component/controller.dart';
import '../../onboarding_screen.dart';
import '../../pages/blog/component/controller.dart';
import '../../pages/chats/component/chat_controller.dart';
import '../../pages/hood/component/controller.dart';
import '../../pages/library/component/controller.dart';
import '../../pages/login/component/controller.dart';
import '../../pages/notification/component/controller.dart';
import '../../pages/settings/component/controller.dart';
import 'package:get/get.dart';

import '../../pages/chats/component/controller.dart';
import '../../signup/component/controller.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => BoardController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => HoodController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => ArticleController());
    Get.lazyPut(() => ChatUIController());
    Get.lazyPut(() => SController());
    Get.lazyPut(() => ChatPlaceController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => LibraryController());
  }
}
