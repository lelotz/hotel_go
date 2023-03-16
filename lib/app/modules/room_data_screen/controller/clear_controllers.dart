import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/laundry_form_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/package_form_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/payment_form_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_details_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_service_controller.dart';
Future<void> deleteRoomControllers()async{
  await Get.delete<PaymentDataController>();
  await Get.delete<RoomDetailsController>();
  await Get.delete<LaundryFormController>();
  await Get.delete<PaymentController>();
  await Get.delete<PackageFormController>();
  await Get.delete<RoomServiceFormController>();
}