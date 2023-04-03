

import 'package:get/get.dart';
import '../controller/payment_form_controller.dart';

class PaymentBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<PaymentController>(() => PaymentController());
    });
  }
}