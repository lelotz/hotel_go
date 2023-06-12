import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/client_user_repo.dart';
import 'package:hotel_pms/app/data/models_n/client_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/guest_dashboard_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:logger/logger.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/services/calulators/stay_calculator.dart';
import '../../../../core/values/localization/messages.dart';
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
      Get.find<HomepageController>().selectedRoomData.value;

  Rx<AdminUser> loggedInUser = Get.find<AuthController>().adminUser;
  AuthController authController = Get.find<AuthController>();

  ClientUser clientUser = ClientUser();

  PaymentDataController payDataController = Get.find<PaymentDataController>();
  GuestDashboardController guestDashboardController =
      Get.find<GuestDashboardController>();


  Rx<List<OtherTransactions>> laundryTransactions = Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> roomServiceTransactions = Rx<List<OtherTransactions>>([]);

  Rx<Map<String, List<OtherTransactions>>> sessionTransactions =
      Rx<Map<String, List<OtherTransactions>>>({});

  Rx<String> payMethod = Rx<String>('');
  Rx<String> payMethodStatus = Rx<String>('');
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

  TextEditingController collectedPaymentInput = TextEditingController();

  Rx<String> selectedBill = Rx<String>(LocalKeys.kSelectBillType.tr);

  Rx<String> selectedPayMethod = Rx<String>('');

  StayCalculator get stayCalculator => StayCalculator(
      roomData: selectedRoom,
      roomTransactionId: selectedRoom.currentTransactionId!);

  @override
  Future<void> onInit() async {
    await getMetaData();
    await calculateAllFees();
    super.onInit();
  }

  assignPaymentDetailsViewValues() {
    grandTotal.value = payDataController.roomTransaction.value.grandTotal!;
    grandTotalAmountPaid.value =
        payDataController.roomTransaction.value.amountPaid!;
    grandTotalOutstandingBalance.value =
        payDataController.roomTransaction.value.outstandingBalance!;
    payDataController.getCurrentRoomTransaction();
  }

  /// Updates UI
  /// Refreshes [roomTransaction] in [PaymentDataController]
  /// Assign to new view data with [assignPaymentDetailsViewValues]
  Future<void> updateGrandTotal() async {
    await payDataController.getCurrentRoomTransaction();
    await assignPaymentDetailsViewValues();
    await updateUI();
  }

  getMetaData() async {
    metaData.value.addAll({
      LocalKeys.kLoggedInUser: loggedInUser,
    });
    metaData.value.addAll({LocalKeys.kSelectedRoom: selectedRoom});
    metaData.value.addAll(
        {LocalKeys.kRoomTransaction: payDataController.roomTransaction});

    /// Use [selectedRoom] to get the current [roomTransaction]
    await RoomTransactionRepository()
        .getRoomTransaction(selectedRoom.currentTransactionId!)
        .then((value) async {
      if (value.id != null) {
        await ClientUserRepository()
            .getClientUser(value.clientId!)
            .then((value) {
          if (value != null && value.isNotEmpty) {
            metaData.value
                .addAll({LocalKeys.kClientUser: value[0]['clientId']});
          }
        });
      }
    });
    await ClientUserRepository()
        .getClientUser(payDataController.roomTransaction.value.clientId!)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        clientUser = ClientUser.fromJson(value[0]);
      }
    });
  }

  Future<void> updateUI() async {}

  calculateAllFees({bool? isLaundryForm = false}) async {
    await assignRoomCost();
    //print('room_cost ${roomCost.value}');

    await calculateLaundryCost();
    logger.v(
        'laundry ${laundryCost.value} items: ${sessionTransactions.value[LocalKeys.kLaundry.toUpperCase()]?.length}');

    await calculateRoomServiceCost();
    logger.v(
        'room_service ${roomServiceCost.value} items: ${sessionTransactions.value[LocalKeys.kRoomService.toUpperCase()]?.length}');

    await assignPaymentDetailsViewValues();
    logger.v('grand_total ${grandTotal.value}');
  }

  /// Calculate roomCost
  Future<void> assignRoomCost() async {
    await payDataController.onInit();
    roomCost.value = payDataController.roomTransaction.value.roomCost!;
    roomBalance.value =
        payDataController.roomTransaction.value.roomOutstandingBalance!;
  }

  Future<void> updateRoomFees() async {
    RoomTransaction roomTransaction = payDataController.roomTransaction.value;
    payDataController.roomTransaction.value =
        await stayCalculator.insertRoomPaymentInRoomTransaction(
            stringToInt(collectedPaymentInput.text), roomTransaction);

    await updateUI();
    await assignRoomCost();

    await RoomTransactionRepository()
        .updateRoomTransaction(roomTransaction.toJson())
        .then((value) async {
      logger.v('UPDATED ROOM: ${roomTransaction.toJson()}');
      await updateUI().then((value) async {
        await assignRoomCost();
        assignPaymentDetailsViewValues();
        await CollectPayment(
          id: const Uuid().v1(),
          clientId: payDataController.roomTransaction.value.clientId,
          clientName: clientUser.fullName,
          employeeId: loggedInUser.value.id,
          employeeName: loggedInUser.value.fullName,
          roomTransactionId: payDataController.roomTransaction.value.id,
          roomNumber: selectedRoom.roomNumber,
          amountCollected: stringToInt(collectedPaymentInput.text),
          dateTime: DateTime.now().toIso8601String(),
          date: extractDate(DateTime.now()),
          time: extractTime(DateTime.now()),
          service: LocalKeys.kRoom,
          payMethod: payMethod.value,
          receiptNumber: const Uuid().v1(),
          sessionId: authController.sessionController.currentSession.value.id,
        ).toDb();
      });
    });
  }

  /// Calculate roomServiceCost
  calculateRoomServiceCost() async {
    roomServiceCost.value = 0;
    roomServiceBalance.value = 0;
    sessionTransactions.value.clear();
    roomServiceTransactions.value.clear();
    await OtherTransactionsRepository()
        .getOtherTransaction(payDataController.roomTransaction.value.id!)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          OtherTransactions roomServiceTransaction =
              OtherTransactions.fromJson(element);
          if (roomServiceTransaction.paymentNotes ==
              TransactionTypes.roomServiceTransaction) {
            roomServiceCost.value += roomServiceTransaction.grandTotal!;
            roomServiceBalance.value +=
                roomServiceTransaction.outstandingBalance!;
            roomServiceTransactions.value.add(roomServiceTransaction);
          }
        }
        sessionTransactions.value.addAll(
            {LocalKeys.kRoomService.toUpperCase(): roomServiceTransactions.value});
      }
    });
  }

  /// Update RoomService Fees with data form [CollectPaymentForm]
 updateRoomServiceFees() async {
    if(sessionTransactions.value.keys.contains(LocalKeys.kRoomService.toUpperCase())){
      int paymentInput = stringToInt(collectedPaymentInput.text);
      await stayCalculator.insertPaymentsInOtherTransactions(
          payment: paymentInput,
          transactions: sessionTransactions.value[LocalKeys.kRoomService.toUpperCase()]!);
      /// Updates [RoomTransaction]
      await updateGrandTotal();
      await CollectPayment(
        id: const Uuid().v1(),
        clientId: payDataController.roomTransaction.value.clientId,
        clientName: clientUser.fullName,
        employeeId: loggedInUser.value.id,
        employeeName: loggedInUser.value.fullName,
        roomTransactionId: payDataController.roomTransaction.value.id,
        roomNumber: selectedRoom.roomNumber,
        amountCollected: stringToInt(collectedPaymentInput.text),
        dateTime: DateTime.now().toIso8601String(),
        date: extractDate(DateTime.now()),
        time: extractTime(DateTime.now()),
        service: TransactionTypes.roomServiceTransaction,
        payMethod: payMethod.value,
        receiptNumber: const Uuid().v1(),
        sessionId: authController.sessionController.currentSession.value.id,

      ).toDb();
      Get.delete<PaymentController>();
    }
  }

  /// Calculate laundryCost
  calculateLaundryCost() async {
    laundryCost.value = 0;
    laundryBalance.value = 0;
    sessionTransactions.value.clear();
    await OtherTransactionsRepository()
        .getOtherTransaction(payDataController.roomTransaction.value.id!)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          OtherTransactions laundryTransaction =
              OtherTransactions.fromJson(element);
          if (laundryTransaction.paymentNotes == AppConstants.laundryLabel) {
            laundryCost.value += laundryTransaction.grandTotal!;
            laundryBalance.value += laundryTransaction.outstandingBalance!;
            laundryTransactions.value.add(laundryTransaction);
          }
        }
        sessionTransactions.value
            .addAll({AppConstants.laundryLabel: laundryTransactions.value});
        logger.v(
            '${sessionTransactions.value[AppConstants.laundryLabel]?.length ?? -1}');
      } else {
        logger.w('No laundry to calculate');
      }
    });
  }

  setPayMethod(String method) {
    payMethod.value = method;
    payMethod.refresh();
  }

  bool validateInputs(){
    bool paymentAmountIsValid = validatePaymentAmount();
    bool billTypeIsSelected = selectedBill.isNotEmpty;
    bool paymentIsGreaterThanZero = stringToInt(collectedPaymentInput.text) > 0;
    bool payMethodIsSelected = validatePayMethod();
    if(collectedPaymentInput.text==LocalKeys.kSelectBillType) {
      payMethodStatus.value = '${payMethodStatus.value}\n - ${AppMessages.cannotCollectZero}';
      return false;
    }
    if(paymentAmountIsValid == false) payMethodStatus.value = 'Huwezi pokea malipo makubwa kuliko deni';

    if( billTypeIsSelected &&
        paymentIsGreaterThanZero &&
        payMethodIsSelected &&
        paymentAmountIsValid
      ) return true;

    if(selectedBill.value == '') payMethodStatus.value = ' - . ${payMethodStatus.value}\n - . ${LocalKeys.kSelectBillType.tr} ${AppMessages.isNotEmpty}';

    return false;
  }

  bool validatePaymentAmount(){
    switch (selectedBill.value) {
      case LocalKeys.kRoom:
        if(stringToInt(collectedPaymentInput.text) > roomBalance.value){
          return false;
        };
        break;
      case LocalKeys.kLaundry :
        if(stringToInt(collectedPaymentInput.text) >  laundryBalance.value){
          return false;
        };

        break;
      case LocalKeys.kRoomService :
        if(stringToInt(collectedPaymentInput.text) > roomServiceBalance.value){
          return false;
        };
        break;
      case LocalKeys.kAll :
        if(stringToInt(collectedPaymentInput.text) > grandTotalOutstandingBalance.value){
          return false;
        };
        break;
      default : return false;
    }
    return true;
  }

  bool validatePayMethod() {
    if (payMethod.value == '') {
      payMethodStatus.value = 'Pay Method ${AppMessages.isNotEmpty}';
      // bookingInitiated.value = false;
      return false;
    } else {
      payMethodStatus.value = '';
    }

    return true;
  }

  /// Update Laundry Fees with data form [CollectPaymentForm]
  updateLaundryFees({bool payingAllBills = false}) async {
      await calculateLaundryCost();
      int paymentInput = stringToInt(collectedPaymentInput.text);
      if(sessionTransactions.value[AppConstants.laundryLabel]==null || sessionTransactions.value[AppConstants.laundryLabel]!.isEmpty) logger.w('no laundry sessions');
      stayCalculator.insertPaymentsInOtherTransactions(
          payment: paymentInput,
          transactions: sessionTransactions.value[AppConstants.laundryLabel] ?? []);

      await CollectPayment(
        id: const Uuid().v1(),
        clientId: payDataController.roomTransaction.value.clientId,
        clientName: clientUser.fullName,
        employeeId:  loggedInUser.value.id,
        employeeName: loggedInUser.value.fullName,
        roomTransactionId: payDataController.roomTransaction.value.id,
        roomNumber: selectedRoom.roomNumber,
        amountCollected: stringToInt(collectedPaymentInput.text),
        dateTime: DateTime.now().toIso8601String(),
        date: extractDate(DateTime.now()),
        time: extractTime(DateTime.now()),
        service: TransactionTypes.laundryPayment,
        payMethod: payMethod.value,
        receiptNumber: const Uuid().v1(),
        sessionId: authController.sessionController.currentSession.value.id,
      ).toDb();
      /// Updates [RoomTransaction]
      await updateGrandTotal();

  }

  Future<void> payAllBills() async {
    await updateRoomFees();
    await updateLaundryFees();
    await updateRoomServiceFees();
  }

  selectBill(String billType) {
    selectedBill.value = billType;
    switch (billType) {
      case LocalKeys.kRoom:
        collectedPaymentInput.text = roomBalance.value.toString();
        break;
      case LocalKeys.kLaundry:
        collectedPaymentInput.text = laundryBalance.value.toString();
        break;
      case LocalKeys.kRoomService:
        collectedPaymentInput.text = roomServiceBalance.value.toString();
        break;
      case LocalKeys.kAll:
        collectedPaymentInput.text =
            grandTotalOutstandingBalance.value.toString();
        break;
    }
  }

  payBill() async {
    switch (selectedBill.value) {
      case LocalKeys.kRoom:
        await updateRoomFees();
        break;
      case LocalKeys.kLaundry:
        await updateLaundryFees();
        break;
      case LocalKeys.kRoomService:
        await updateRoomServiceFees();
        break;
      case LocalKeys.kAll:
        await payAllBills();
        break;
    }
    await guestDashboardController.getUserActivity();
    guestDashboardController.update();
    Navigator.of(Get.overlayContext!).pop();
    Get.delete<PaymentController>();
  }
}
