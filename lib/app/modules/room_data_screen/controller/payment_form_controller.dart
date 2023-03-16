import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/client_user_repo.dart';
import 'package:hotel_pms/app/data/models_n/client_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_details_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:logger/logger.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../data/local_storage/repository/other_transactions_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/models_n/admin_user_model.dart';
import '../../../data/models_n/room_data_model.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../login_screen/controller/auth_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:hotel_pms/core/values/app_constants.dart';

/// Calculates and Updates Fees to pay based on
/// the current [RoomTransaction] supplied by the
/// [RoomDetailsController]

class PaymentController extends GetxController {
  Logger logger = AppLogger.instance.logger;
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

  ClientUser clientUser = ClientUser();

  PaymentDataController payDataController = Get.find<PaymentDataController>();

  List<OtherTransactions> laundryTransactions = [];
  List<OtherTransactions> roomServiceTransactions = [];

  Rx<Map<String, List<OtherTransactions>>> sessionTransactions = Rx<
      Map<String, List<OtherTransactions>>>({});



  Rx<Map<String, dynamic>> metaData = Rx<Map<String, dynamic>>({});


  Rx<int> roomCost = Rx<int>(0);
  Rx<int> roomBalance = Rx<int>(0);

  Rx<int> roomServiceCost = Rx<int>(0);
  Rx<int> roomServiceBalance = Rx<int>(0);

  Rx<int> laundryCost = Rx<int>(0);
  Rx<int> laundryBalance = Rx<int>(0);

  Rx<int> grandTotal = Rx<int>(0);
  Rx<int> grandTotalOutstandingBalance = Rx<int>(0);
  Rx<int> grandTotalAmountPaid = Rx<int>(0);

  Map<String, dynamic> allocatedPayments = {};

  TextEditingController collectedPaymentInputCtrl = TextEditingController();

  Rx<String> selectedBill = Rx<String>("");

  @override
  void onInit() async {
    await getMetaData();
    await calculateAllFees();
    super.onInit();
  }

  assignGrandTotalValues() {
    grandTotal.value = payDataController.roomTransaction.value.grandTotal!;
    grandTotalAmountPaid.value = payDataController.roomTransaction.value.amountPaid!;
    grandTotalOutstandingBalance.value = payDataController.roomTransaction.value.outstandingBalance!;
    payDataController.getCurrentRoomTransaction();
  }

  /// Update [RoomTransaction] with data form [CollectPaymentForm]
  /// Upload updated [RoomTransaction] to Db
  /// Assign to new data with [assignGrandTotalValues]
  Future<void> updateGrandTotal() async {
    payDataController.roomTransaction.value.amountPaid =
        payDataController.roomTransaction.value.amountPaid! +
            stringToInt(collectedPaymentInputCtrl.text);

    payDataController.roomTransaction.value.outstandingBalance =
        payDataController.roomTransaction.value.grandTotal! -
            payDataController.roomTransaction.value.amountPaid!;

    await RoomTransactionRepository().updateRoomTransaction(
        payDataController.roomTransaction.value.toJson()).then((value) async {
      await updateUI();
      assignGrandTotalValues();
    });
  }

  getMetaData() async {
    metaData.value.addAll({LocalKeys.kLoggedInUser: loggedInUser,});
    metaData.value.addAll({LocalKeys.kSelectedRoom: selectedRoom});
    metaData.value.addAll({LocalKeys.kRoomTransaction: payDataController.roomTransaction});


    /// Use [selectedRoom] to get the current [roomTransaction]
    await RoomTransactionRepository().getRoomTransaction(
        selectedRoom.currentTransactionId!).then((value) async {
      if (value != null && value.isNotEmpty) {
        await ClientUserRepository().getClientUser(value[0]['clientId'])
            .then((value) {
          if (value != null && value.isNotEmpty) {
            metaData.value.addAll(
                {LocalKeys.kClientUser: value[0]['clientId']});
          }
        });
      }
    });
    await ClientUserRepository().getClientUser(payDataController.roomTransaction.value.clientId!).then((value) {
      if(value!= null && value.isNotEmpty){
        clientUser = ClientUser.fromJson(value[0]);
      }
    });
  }

  Future<void> updateUI() async {}

  calculateAllFees({bool? isLaundryForm=false}) async {
    await assignRoomCost();
    //print('room_cost ${roomCost.value}');

    await calculateLaundryCost();
    logger.v('laundry ${laundryCost.value} items: ${sessionTransactions.value[LocalKeys.kLaundry.toUpperCase()]?.length}');

    await calculateRoomServiceCost();
    logger.v('room_service ${roomServiceCost.value} items: ${sessionTransactions.value[LocalKeys.kRoomService.toUpperCase()]?.length}');


    await assignGrandTotalValues();
    logger.v('grand_total ${grandTotal.value}');
  }

  /// Calculate roomCost
  Future<void> assignRoomCost() async{
    await payDataController.onInit();
    roomCost.value = payDataController.roomTransaction.value.roomCost!;
    roomBalance.value = payDataController.roomTransaction.value.roomOutstandingBalance!;
  }


  Future<void> updateRoomFees() async {
    collectedPaymentInputCtrl.text = roomBalance.value.toString();
    RoomTransaction roomTransaction = payDataController.roomTransaction.value;

    /// Add the input new payment to the current [RoomTransaction] Object
    /// This updates the roomAmountPaid value of the [RoomTransaction] Object
    roomTransaction.roomAmountPaid = roomTransaction.roomAmountPaid! +
        stringToInt(collectedPaymentInputCtrl.text);
    roomTransaction.roomOutstandingBalance =
        roomTransaction.roomCost! - roomTransaction.roomAmountPaid!;

    roomTransaction.amountPaid = roomTransaction.amountPaid! +
        stringToInt(collectedPaymentInputCtrl.text);
    roomTransaction.outstandingBalance = roomTransaction.outstandingBalance! -
        stringToInt(collectedPaymentInputCtrl.text);

    payDataController.roomTransaction.value = roomTransaction;

    await RoomTransactionRepository().updateRoomTransaction(
        roomTransaction.toJson()).then((value) async {
      logger.v('UPDATED ROOM: ${roomTransaction.toJson()}');
      await updateUI().then((value) async {
        await assignRoomCost();
        assignGrandTotalValues();
        await CollectPayment(
          id: const Uuid().v1(),
          clientId: payDataController.roomTransaction.value.clientId,
          clientName: clientUser.fullName,
          employeeId: loggedInUser.appId,
          employeeName: loggedInUser.fullName,
          roomTransactionId: payDataController.roomTransaction.value.id,
          roomNumber: selectedRoom.roomNumber,
          amountCollected: stringToInt(collectedPaymentInputCtrl.text),
          dateTime: DateTime.now().toIso8601String(),
          date: extractDate(DateTime.now()),
          time: extractTime(DateTime.now()),
          service: LocalKeys.kRoom,
          payMethod: "CASH",
          receiptNumber: const Uuid().v1(),

        ).toDb();
      });
    });
  }

  /// Calculate roomServiceCost
  calculateRoomServiceCost()async{
    roomServiceCost.value = 0;
    roomServiceBalance.value = 0;
    sessionTransactions.value.clear();
    roomServiceTransactions.clear();
    await  OtherTransactionsRepository().getOtherTransaction(payDataController.roomTransaction.value.id!).then((value) {
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          OtherTransactions roomServiceTransaction = OtherTransactions.fromJson(element);
          if(roomServiceTransaction.paymentNotes == TransactionTypes.roomServiceTransaction){
            roomServiceCost.value += roomServiceTransaction.grandTotal!;
            roomServiceBalance.value += roomServiceTransaction.outstandingBalance!;
            roomServiceTransactions.add(roomServiceTransaction);
            sessionTransactions.value.addAll({LocalKeys.kRoomService.toUpperCase():roomServiceTransactions});
          }
        }
      }
    });
  }


  /// Update RoomService Fees with data form [CollectPaymentForm]
  updateRoomServiceFees() async {
    //await calculateRoomServiceCost();
    int paymentInput = stringToInt(collectedPaymentInputCtrl.text);
    int currentRoomServiceTransactionCost = 0;
    collectedPaymentInputCtrl.text = roomServiceBalance.value.toString();
    for(OtherTransactions roomServiceTransaction in sessionTransactions.value[LocalKeys.kRoomService.toUpperCase()]!){
      if(roomServiceTransaction.outstandingBalance! > 0){
        currentRoomServiceTransactionCost = paymentInput - (paymentInput - roomServiceTransaction.grandTotal!);
        roomServiceTransaction.amountPaid = currentRoomServiceTransactionCost;
        roomServiceTransaction.outstandingBalance = roomServiceTransaction.grandTotal! - roomServiceTransaction.amountPaid!;
        paymentInput = paymentInput - currentRoomServiceTransactionCost;
        await  OtherTransactionsRepository().updateOtherTransaction(roomServiceTransaction.toJson(),);
      }
    }
    /// Updates [RoomTransaction]
    await updateGrandTotal();
    await CollectPayment(
      id: const Uuid().v1(),
      clientId: payDataController.roomTransaction.value.clientId,
      clientName: clientUser.fullName,
      employeeId: loggedInUser.appId,
      employeeName: loggedInUser.fullName,
      roomTransactionId: payDataController.roomTransaction.value.id,
      roomNumber: selectedRoom.roomNumber,
      amountCollected: stringToInt(collectedPaymentInputCtrl.text),
      dateTime: DateTime.now().toIso8601String(),
      date: extractDate(DateTime.now()),
      time: extractTime(DateTime.now()),
      service: TransactionTypes.roomServiceTransaction,
      payMethod: "CASH",
      receiptNumber: const Uuid().v1(),

    ).toDb();
    Get.delete<PaymentController>();
  }

  /// Calculate laundryCost
  calculateLaundryCost() async {
    laundryCost.value = 0;
    laundryBalance.value = 0;
    sessionTransactions.value.clear();
    await  OtherTransactionsRepository().getOtherTransaction(payDataController.roomTransaction.value.id!).then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          OtherTransactions laundryTransaction = OtherTransactions.fromJson(element);
          if (laundryTransaction.paymentNotes == LocalKeys.kLaundry.toUpperCase()) {
            laundryCost.value += laundryTransaction.grandTotal!;
            laundryBalance.value += laundryTransaction.outstandingBalance!;
            laundryTransactions.add(laundryTransaction);
            sessionTransactions.value.addAll({LocalKeys.kLaundry.toUpperCase(): laundryTransactions});
          }
        }
      }else{
        logger.w('No laundry to calculate');
      }
    });
  }


  /// Update Laundry Fees with data form [CollectPaymentForm]
  updateLaundryFees() async {
    //print('[UPD]sessionData ${sessionTransactions.value[LocalKeys.kLaundry.toUpperCase()]?.length ?? -1}');
    await calculateLaundryCost();
    //print('[UPD 1]sessionData ${sessionTransactions.value[LocalKeys.kLaundry.toUpperCase()]?.length ?? -1}');
    int paymentInput = stringToInt(collectedPaymentInputCtrl.text);
    int currentLaundryTransactionCost = 0;
    collectedPaymentInputCtrl.text = laundryBalance.value.toString();

    for (OtherTransactions laundryTransaction in sessionTransactions.value[LocalKeys.kLaundry.toUpperCase()] ?? []) {
      if (laundryTransaction.outstandingBalance! > 0) {
        currentLaundryTransactionCost = paymentInput - (paymentInput - laundryTransaction.grandTotal!);
        laundryTransaction.amountPaid = currentLaundryTransactionCost;
        laundryTransaction.outstandingBalance = laundryTransaction.grandTotal! - laundryTransaction.amountPaid!;
        paymentInput = paymentInput - currentLaundryTransactionCost;

        await OtherTransactionsRepository().updateOtherTransaction(laundryTransaction.toJson());
      }
    }


    await CollectPayment(
      id: const Uuid().v1(),
      clientId: payDataController.roomTransaction.value.clientId,
      clientName: clientUser.fullName,
      employeeId: loggedInUser.appId,
      employeeName: loggedInUser.fullName,
      roomTransactionId: payDataController.roomTransaction.value.id,
      roomNumber: selectedRoom.roomNumber,
      amountCollected: stringToInt(collectedPaymentInputCtrl.text),
      dateTime: DateTime.now().toIso8601String(),
      date: extractDate(DateTime.now()),
      time: extractTime(DateTime.now()),
      service: TransactionTypes.laundryPayment,
      payMethod: "CASH",
      receiptNumber: const Uuid().v1(),
    ).toDb();
    /// Updates [RoomTransaction]
    await updateGrandTotal();

  }

  selectBill(String billType) {
    selectedBill.value = billType;
    switch (billType) {
      case LocalKeys.kRoom:
        collectedPaymentInputCtrl.text = roomBalance.value.toString();
        break;
      case LocalKeys.kLaundry :
        collectedPaymentInputCtrl.text = laundryBalance.value.toString();
        break;
      case LocalKeys.kRoomService :
        collectedPaymentInputCtrl.text = roomServiceBalance.value.toString();
        break;
      case LocalKeys.kAll :
        collectedPaymentInputCtrl.text =
            grandTotalOutstandingBalance.value.toString();
        break;
    }
  }

  payBill() async {
    switch (selectedBill.value) {
      case LocalKeys.kRoom:
        await updateRoomFees();
        break;
      case LocalKeys.kLaundry :
        await updateLaundryFees();
        break;
      case LocalKeys.kRoomService :
        await updateRoomServiceFees();
        break;
      case LocalKeys.kAll :
        collectedPaymentInputCtrl.text =
            grandTotalOutstandingBalance.value.toString();
        break;
    }
  }


}
