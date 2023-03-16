
import 'package:get/get.dart';
import '../controller/room_details_controller.dart';

class GuestDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<RoomDetailsController>(() => RoomDetailsController());
    });
  }
}