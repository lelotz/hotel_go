import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_form_controller.dart';

import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/other_transactions_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import 'guest_dashboard_controller.dart';


class LaundryFormController extends GetxController{
  Rx<Map<String,dynamic>> get metaData => Get.find<GuestDashboardController>().metaData;
  Rx<List<UserActivity>> get userActivity => Get.find<GuestDashboardController>().userActivity;
  Rx<int> get userActivityCount => Get.find<GuestDashboardController>().userActivityCount;
  PaymentController paymentController = Get.put(PaymentController());

  Rx<List<OtherTransactions>> receivedLaundryView = Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> receivedLaundryBuffer = Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> returnedLaundryBuffer = Rx<List<OtherTransactions>>([]);


  Rx<int> returnedLaundryBufferCount = Rx<int>(0);
  Rx<int> receivedLaundryBufferCount = Rx<int>(0);
  Rx<int> receivedLaundryViewCount = Rx<int>(0);


  TextEditingController laundryDescriptionCtrl = TextEditingController();
  TextEditingController laundryQuantityCtrl = TextEditingController();

  Rx<bool> returningLaundry = Rx<bool>(false);
  Rx<bool> receivingLaundry = Rx<bool>(true);

  @override
  onInit()async{
    await getOtherTransactions();
    super.onInit();


  }
  updateUI(){
    userActivityCount.value = userActivity.value.length;
    receivedLaundryViewCount.value = receivedLaundryView.value.length;
    receivedLaundryBufferCount.value = receivedLaundryBuffer.value.length;
  }

  Future<void> getOtherTransactions()async{
    await OtherTransactionsRepository().getOtherTransaction(metaData.value[LocalKeys.kRoomTransaction].value.id).then((response) {
      if(response != null){
        for(Map<String,dynamic> element in response){
          receivedLaundryView.value.add(OtherTransactions.fromJson(element));
        }
        showSnackBar("Fetched Other Transactions", Get.context!);
      }else{
        showSnackBar("FAILED TO Fetch Other Transactions", Get.context!);
      }
    });
  }



  void bufferNewStoredLaundry(){

    OtherTransactions newLaundry = OtherTransactions(
      id: const Uuid().v1(),
      roomTransactionId: metaData.value[LocalKeys.kRoomTransaction].value.id,
      clientId: metaData.value[LocalKeys.kClientUser].value.clientId,
      employeeId: metaData.value[LocalKeys.kLoggedInUser].appId,
      dateTime: DateTime.now().toIso8601String(),
      paymentNotes: AppConstants.laundryLabel,
      transactionNotes: '${laundryQuantityCtrl.text}:${laundryDescriptionCtrl.text}',
      roomNumber: metaData.value[LocalKeys.kSelectedRoom].roomNumber,
      grandTotal: stringToInt(laundryQuantityCtrl.text) * AppConstants.laundryPrice,
      amountPaid: 0,
      outstandingBalance: stringToInt(laundryQuantityCtrl.text) * AppConstants.laundryPrice,
    );
    receivedLaundryBuffer.value.add(newLaundry);
    update();
    receivedLaundryBuffer.refresh();
    updateUI();
    showSnackBar("Updated UI", Get.context!);

  }

  /// Uploads [OtherTransactions] laundry objects and creates their
  /// corresponding [UserActivity] object.
  Future<void> storeNewLaundry()async{
    for(OtherTransactions newLaundry in receivedLaundryBuffer.value){
      await OtherTransactionsRepository().createOtherTransaction(newLaundry.toJson()).then((value) async{
        UserActivity laundryActivity = UserActivity(
          activityId: newLaundry.id,
          guestId: newLaundry.clientId,
          employeeId: newLaundry.employeeId,
          employeeFullName: metaData.value[LocalKeys.kLoggedInUser].fullName,
          roomTransactionId: newLaundry.roomTransactionId,
          activityStatus: "${LocalKeys.kReceive} ${LocalKeys.kLaundry}",
          description: newLaundry.transactionNotes?.split(":")[1],
          unit: newLaundry.transactionNotes?.split(":")[0],
          activityValue: newLaundry.grandTotal,
          dateTime: newLaundry.dateTime,
        );
        await UserActivityRepository().createUserActivity(
            laundryActivity.toJson()
        ).then((value)async{
          RoomTransaction roomTransaction = metaData.value[LocalKeys.kRoomTransaction].value;
          roomTransaction.grandTotal = roomTransaction.grandTotal! + newLaundry.grandTotal!;
          roomTransaction.otherCosts = roomTransaction.otherCosts! + newLaundry.grandTotal!;
          roomTransaction.outstandingBalance = roomTransaction.grandTotal! - roomTransaction.amountPaid!;
          await RoomTransactionRepository().updateRoomTransaction(roomTransaction.toJson());
          userActivity.value.add(laundryActivity);
          receivedLaundryView.value.add(newLaundry);
          Get.find<PaymentDataController>().getCurrentRoomTransaction();
          paymentController.calculateAllFees(isLaundryForm: true);
          //paymentController.calculateLaundryCost();
        });
      });
    }

    receivedLaundryBuffer.value.clear();
    clearLaundryFormInputs();
    updateUI();
    Get.find<GuestDashboardController>().updateUI();
  }


  /// This Stores Laundry Transactions that have not been returned in [receivedLaundryView]
  /// Search for [OtherOperations] object that has
  /// [OtherOperations.paymentNotes] = [AppConstants.laundryLabel], and
  /// [OtherOperations.roomTransaction.id] = [roomTransaction.value.id], and
  /// Add this object to [receivedLaundryView]
  Future<void> getStoredLaundry()async{
    receivedLaundryView.value.clear();
    await OtherTransactionsRepository().getOtherTransaction(metaData.value[LocalKeys.kRoomTransaction].value.id).then((value) {
      if(value != null  && value.isNotEmpty ){
        for(Map<String,dynamic> element in value){
          if(element[OtherTransactionsTable.paymentNotes] == AppConstants.laundryLabel){
            receivedLaundryView.value.add(OtherTransactions.fromJson(element));
          }
        }
        showSnackBar("Loaded Stored Laundry: ${receivedLaundryView.value.first.transactionNotes}", Get.context!);
      }else{
        showSnackBar("FAILED: To Load Stored Laundry", Get.context!);
        print('FAILED: To Load Stored Laundry');

      }
    });
    updateUI();

  }

  /// Stores the [OtherTransactions] laundryObject in memory
  /// In [returnedLaundryBuffer]
  void bufferReturnedLaundryItems(OtherTransactions laundryObject){
    returnedLaundryBuffer.value.add(laundryObject);
    receivedLaundryView.value.remove(laundryObject);
    updateUI();
  }

  /// Store returned laundry objects to in [receivedLaundryBuffer]
  /// This list will be used to upload these objects to the database
  void returnLaundryItems()async{
    for(OtherTransactions laundryObject in returnedLaundryBuffer.value){
      laundryObject.outstandingBalance = laundryObject.grandTotal! - stringToInt("0");
      await OtherTransactionsRepository().updateOtherTransaction(laundryObject.toJson()).then((value) async{
        if(value! > 0){
          UserActivity returnActivity = UserActivity(
            activityId: const Uuid().v1(),
            guestId: metaData.value[LocalKeys.kClientUser].value.clientId,
            roomTransactionId: metaData.value[LocalKeys.kRoomTransaction].value.id,
            employeeId: metaData.value[LocalKeys.kLoggedInUser].appId,
            employeeFullName: metaData.value[LocalKeys.kLoggedInUser].fullName,
            activityValue: 0,
            activityStatus: "${LocalKeys.kReturn} ${LocalKeys.kLaundry}",
            description: laundryObject.transactionNotes!.split(":")[1],
            unit: laundryObject.transactionNotes!.split(":")[0],
            dateTime: DateTime.now().toIso8601String(),
          );
          userActivity.value.add(returnActivity);

          await UserActivityRepository().createUserActivity(returnActivity.toJson()).then((value) {
            showSnackBar("Returned Laundry", Get.context!);
          });
        }else{
          showSnackBar("FAILED Laundry", Get.context!);
        }

      });
      showSnackBar("${laundryObject.transactionNotes}", Get.context!);
    }
    clearLaundryFormInputs();
    Navigator.of(Get.overlayContext!);
    updateUI();

  }

  receiveLaundry(){
    receivingLaundry.value = true;
    returningLaundry.value = false;
  }

  returnLaundry(){
    receivingLaundry.value = false;
    returningLaundry.value = true;
    getStoredLaundry();
  }

  clearLaundryFormInputs(){
    laundryQuantityCtrl.clear();
    laundryDescriptionCtrl.clear();
  }
}