import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/splash_screen/controller/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    });
  }
}