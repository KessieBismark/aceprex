import 'package:get/get.dart';

import 'controller.dart';

class SBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SController());
  }
}
