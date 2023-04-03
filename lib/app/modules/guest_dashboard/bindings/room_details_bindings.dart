
import 'package:get/get.dart';
import '../controller/guest_dashboard_controller.dart';

class GuestDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<GuestDashboardController>(() => GuestDashboardController());
    });
  }
}