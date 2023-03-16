
import 'package:get/get.dart';
import '../controller/laundry_form_controller.dart';

class LaundryFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<LaundryFormController>(() => LaundryFormController());
    });
  }
}