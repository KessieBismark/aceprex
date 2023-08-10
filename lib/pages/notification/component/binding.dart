import 'package:aceprex/pages/notification/component/controller.dart';
import 'package:get/get.dart';

class NotBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
