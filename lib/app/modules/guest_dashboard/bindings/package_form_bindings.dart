

import 'package:get/get.dart';


import '../controller/package_form_controller.dart';


class PackageFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<PackageFormController>(() => PackageFormController());
    });
  }
}