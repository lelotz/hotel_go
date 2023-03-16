

import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/package_form_controller.dart';


class PackageFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<PackageFormController>(() => PackageFormController());
    });
  }
}