import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/package_form_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_form_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/room_service_controller.dart';


import 'guest_dashboard_controller.dart';
import 'laundry_form_controller.dart';
Future<void> deleteRoomControllers()async{
  await Get.delete<PaymentDataController>();
  await Get.delete<GuestDashboardController>();
  await Get.delete<LaundryFormController>();
  await Get.delete<PaymentController>();
  await Get.delete<PackageFormController>();
  await Get.delete<RoomServiceFormController>();
}