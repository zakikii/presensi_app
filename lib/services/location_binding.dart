import 'package:get/get.dart';

import 'location_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocationController>(
      LocationController(),
    );
  }
}
