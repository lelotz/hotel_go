
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_service_controller.dart';


class RoomServiceBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() {
      Get.lazyPut<RoomServiceFormController>(() => RoomServiceFormController());
    });
  }
}