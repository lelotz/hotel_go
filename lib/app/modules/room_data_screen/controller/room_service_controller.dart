
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/payment_form_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_details_controller.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/values/app_constants.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/other_transactions_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/models_n/admin_user_model.dart';
import '../../../data/models_n/room_data_model.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../login_screen/controller/auth_controller.dart';
class RoomServiceFormController extends GetxController{
  RoomData get selectedRoom =>
      Get
          .find<HomepageController>()
          .selectedRoomData
          .value;

  AdminUser get loggedInUser =>
      Get
          .find<AuthController>()
          .adminUser
          .value;
  PaymentController paymentController = Get.put(PaymentController());
  PaymentDataController payDataController = Get.find<PaymentDataController>();

  TextEditingController serviceDescription = TextEditingController();
  TextEditingController serviceCost = TextEditingController();

  Rx<List<OtherTransactions>> receivedRoomServiceBuffer = Rx<List<OtherTransactions>>([]);
  Rx<int> roomServiceBufferCount = 0.obs;



  updateUI(){
    roomServiceBufferCount.value = receivedRoomServiceBuffer.value.length;
    showSnackBar("Updated UI", Get.context!);
  }

  clearFormInputs(){
    serviceCost.clear();
    serviceDescription.clear();
  }
  addRoomServiceToBuffer(){
    OtherTransactions roomService = OtherTransactions(
      id: const Uuid().v1(),
      clientId: payDataController.roomTransaction.value.clientId,
      employeeId: loggedInUser.appId,
      roomTransactionId: payDataController.roomTransaction.value.id,
      roomNumber: selectedRoom.roomNumber,
      transactionNotes:serviceDescription.text,
      paymentNotes:  TransactionTypes.roomServiceTransaction,
      dateTime: DateTime.now().toIso8601String(),
      grandTotal: stringToInt(serviceCost.text),
      outstandingBalance: stringToInt(serviceCost.text),
      amountPaid: 0,
    );
    receivedRoomServiceBuffer.value.add(roomService);
    updateUI();
    clearFormInputs();
  }

  Future<void> storeRoomServices() async{
    for(OtherTransactions roomService in receivedRoomServiceBuffer.value) {
      await OtherTransactionsRepository().createOtherTransaction(roomService.toJson()).then((value) async {
        payDataController.roomTransaction.value.otherCosts = payDataController.roomTransaction.value.otherCosts!+roomService.grandTotal!;
        payDataController.roomTransaction.value.grandTotal = payDataController.roomTransaction.value.grandTotal!+roomService.grandTotal!;
        payDataController.roomTransaction.value.outstandingBalance = payDataController.roomTransaction.value.outstandingBalance! + roomService.grandTotal!;
        await RoomTransactionRepository().updateRoomTransaction(payDataController.roomTransaction.value.toJson()).then((value) async{
          payDataController.getCurrentRoomTransaction();
        });
      });
    }
    receivedRoomServiceBuffer.value.clear();
    paymentController.calculateAllFees();
    Get.find<RoomDetailsController>().updateUI();
    updateUI();
  }

}