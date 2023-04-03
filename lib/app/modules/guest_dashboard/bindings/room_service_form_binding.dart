
import 'package:get/get.dart';
import '../controller/room_service_controller.dart';


class RoomServiceBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<RoomServiceFormController>(() => RoomServiceFormController());
    });
  }
}