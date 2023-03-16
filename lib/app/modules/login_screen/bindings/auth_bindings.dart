
import 'package:get/get.dart';

import '../controller/auth_controller.dart';


class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<AuthController>(() => AuthController());
    });
  }


}