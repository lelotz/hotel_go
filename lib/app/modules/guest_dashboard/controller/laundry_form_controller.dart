import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_form_controller.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';

import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/other_transactions_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../data/models_n/admin_user_model.dart';
import 'guest_dashboard_controller.dart';

class LaundryFormController extends GetxController {
  Logger logger = AppLogger.instance.logger;

  Rx<Map<String, dynamic>> get metaData =>
      Get.find<GuestDashboardController>().metaData;
  Rx<AdminUser> loggedInUser =
      Get.find<GuestDashboardController>().loggedInUser;

  Rx<List<UserActivity>> get userActivity =>
      Get.find<GuestDashboardController>().userActivity;

  Rx<int> get userActivityCount =>
      Get.find<GuestDashboardController>().userActivityCount;
  PaymentController paymentController = Get.put(PaymentController());

  Rx<List<OtherTransactions>> receivedLaundryView =
      Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> receivedLaundryBuffer =
      Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> returnedLaundryBuffer =
      Rx<List<OtherTransactions>>([]);

  Rx<int> returnedLaundryBufferCount = Rx<int>(0);
  Rx<int> receivedLaundryBufferCount = Rx<int>(0);
  Rx<int> receivedLaundryViewCount = Rx<int>(0);

  TextEditingController laundryDescriptionCtrl = TextEditingController();
  TextEditingController laundryQuantityCtrl = TextEditingController();
  TextEditingController laundryPriceCtrl = TextEditingController();

  Rx<bool> returningLaundry = Rx<bool>(false);
  Rx<bool> receivingLaundry = Rx<bool>(true);

  Rx<List<AdminUser>> houseKeepingStaff = Rx<List<AdminUser>>([]);
  Rx<AdminUser> selectedHouseKeeper = Rx<AdminUser>(AdminUser());
  Rx<List<String>> houseKeepingStaffNames = Rx<List<String>>([]);
  Rx<String> selectedHouseKeeperName = Rx<String>('');

  @override
  onInit() async {
    super.onInit();
    await getHouseKeepingStaff();
    await getOtherTransactions();
  }

  getHouseKeepingStaffName() {
    houseKeepingStaffNames.value.clear();
    for (AdminUser housekeeper in houseKeepingStaff.value) {
      houseKeepingStaffNames.value.add(housekeeper.fullName!);
    }
    houseKeepingStaffNames.refresh();
  }

  getHouseKeepingStaff() async {
    await AdminUserRepository()
        .getAdminUserByPosition(LocalKeys.kHouseKeeping)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        houseKeepingStaff.value = AdminUser().fromJsonList(value);
        getHouseKeepingStaffName();
      }
    });
    logger.i({'housekeepers': '${houseKeepingStaffNames.value.length}'});
  }

  updateUI() {
    userActivityCount.value = userActivity.value.length;
    receivedLaundryViewCount.value = receivedLaundryView.value.length;
    receivedLaundryBufferCount.value = receivedLaundryBuffer.value.length;
    receivedLaundryView.refresh();
    receivedLaundryBuffer.refresh();
    returnedLaundryBuffer.refresh();

  }

  selectHouseKeeper(String houseKeeper) {
    selectedHouseKeeperName.value = houseKeeper;
  }

  Future<void> getOtherTransactions() async {
    await OtherTransactionsRepository()
        .getOtherTransaction(
            metaData.value[LocalKeys.kRoomTransaction].value.id)
        .then((response) {
      if (response != null) {
        for (Map<String, dynamic> element in response) {
          receivedLaundryView.value.add(OtherTransactions.fromJson(element));
        }
        showSnackBar("Fetched Other Transactions", Get.context!);
      } else {
        showSnackBar("FAILED TO Fetch Other Transactions", Get.context!);
      }
    });
  }

  void bufferNewStoredLaundry() {
    OtherTransactions newLaundry = OtherTransactions(
      id: const Uuid().v1(),
      roomTransactionId: metaData.value[LocalKeys.kRoomTransaction].value.id,
      clientId: metaData.value[LocalKeys.kClientUser].value.clientId,
      employeeId: metaData.value[LocalKeys.kLoggedInUser].value.appId,
      dateTime: DateTime.now().toIso8601String(),
      paymentNotes: AppConstants.laundryLabel,
      transactionNotes:
          '${laundryQuantityCtrl.text}:${laundryDescriptionCtrl.text}:${LocalKeys.kReceive}',
      roomNumber: metaData.value[LocalKeys.kSelectedRoom].roomNumber,
      grandTotal: stringToInt(laundryPriceCtrl.text),
      amountPaid: 0,
      outstandingBalance: stringToInt(laundryPriceCtrl.text),
    );
    receivedLaundryBuffer.value.add(newLaundry);

    update();
    // receivedLaundryBuffer.refresh();
    updateUI();
  }

  /// Uploads [OtherTransactions] laundry objects and creates their
  /// corresponding [UserActivity] object.
  Future<void> storeNewLaundry() async {
    if (selectedHouseKeeperName.value != '') {
      for (OtherTransactions newLaundry in receivedLaundryBuffer.value) {
        await OtherTransactionsRepository()
            .createOtherTransaction(newLaundry.toJson())
            .then((value) async {
          UserActivity laundryActivity = UserActivity(
            activityId: newLaundry.id,
            guestId: newLaundry.clientId,
            employeeId: newLaundry.employeeId,
            employeeFullName:
                metaData.value[LocalKeys.kLoggedInUser].value.fullName,
            roomTransactionId: newLaundry.roomTransactionId,
            activityStatus: "${LocalKeys.kReceive} ${LocalKeys.kLaundry}",
            description: newLaundry.transactionNotes?.split(":")[1],
            unit: newLaundry.transactionNotes?.split(":")[0],
            activityValue: newLaundry.grandTotal,
            dateTime: newLaundry.dateTime,
          );
          await UserActivityRepository()
              .createUserActivity(laundryActivity.toJson())
              .then((value) async {
            RoomTransaction roomTransaction = metaData.value[LocalKeys.kRoomTransaction].value;
            roomTransaction.grandTotal = roomTransaction.grandTotal! + newLaundry.grandTotal!;
            roomTransaction.otherCosts = roomTransaction.otherCosts! + newLaundry.grandTotal!;
            // roomTransaction.amountPaid = roomTransaction.amountPaid! + newLaundry.amountPaid!;
            roomTransaction.outstandingBalance =
                roomTransaction.grandTotal! - roomTransaction.amountPaid!;
            await RoomTransactionRepository()
                .updateRoomTransaction(roomTransaction.toJson());
            userActivity.value.add(laundryActivity);
            receivedLaundryView.value.add(newLaundry);
            Get.find<PaymentDataController>().getCurrentRoomTransaction();
            paymentController.calculateAllFees(isLaundryForm: true);
            //paymentController.calculateLaundryCost();
          });

          await AdminUserRepository()
              .getAdminUserByName(selectedHouseKeeperName.value)
              .then((value) async{
                if(value!=null){
                  selectedHouseKeeper.value = AdminUser.fromJson(value.first);
                  selectedHouseKeeper.value = AdminUser.incrementRoomsSold(selectedHouseKeeper.value.toJson());
                  await AdminUserRepository().updateAdminUser(selectedHouseKeeper.value.toJson());
                  logger.i({'hk': selectedHouseKeeper.value.roomsSold});
                }else{
                  logger.w({'hk': selectedHouseKeeperName.value});
                }
          });

        });
      }

      receivedLaundryBuffer.value.clear();
      clearLaundryFormInputs();
      updateUI();
      Get.find<GuestDashboardController>().updateUI();
    }
  }

  /// This Stores Laundry Transactions that have not been returned in [receivedLaundryView]
  /// Search for [OtherOperations] object that has
  /// [OtherOperations.paymentNotes] = [AppConstants.laundryLabel], and
  /// [OtherOperations.roomTransaction.id] = [roomTransaction.value.id], and
  /// Add this object to [receivedLaundryView]
  Future<void> getStoredLaundry() async {
    receivedLaundryView.value.clear();
    await OtherTransactionsRepository()
        .getOtherTransaction(
            metaData.value[LocalKeys.kRoomTransaction].value.id)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          if (element[OtherTransactionsTable.paymentNotes] ==
              AppConstants.laundryLabel) {
            if (OtherTransactions.fromJson(element)
                    .transactionNotes!
                    .split(':')[2] ==
                LocalKeys.kReceive) {
              receivedLaundryView.value.add(OtherTransactions.fromJson(element));
              receivedLaundryView.refresh();
            }
          }
        }
        showSnackBar(
            "Loaded Stored Laundry: ${receivedLaundryView.value.length}",
            Get.context!);
      } else {
        showSnackBar("No Laundry Stored", Get.context!);
      }
    });
    updateUI();
  }

  /// Stores the [OtherTransactions] laundryObject in memory
  /// In [returnedLaundryBuffer]
  void bufferReturnedLaundryItems(OtherTransactions laundryObject) {
    if (returnedLaundryBuffer.value.contains(laundryObject)) {
      returnedLaundryBuffer.value.remove(laundryObject);
    } else {

      returnedLaundryBuffer.value.add(laundryObject);
    }
    returnedLaundryBuffer.refresh();
    updateUI();
  }

  OtherTransactions updateLaundryStatus(OtherTransactions laundryObject,{bool returning = false}){
    OtherTransactions updatedObject = laundryObject;
    String quantity = "";
    String type = "";
    String status = "";
    quantity = laundryObject.transactionNotes!.split(':')[0];
    type = laundryObject.transactionNotes!.split(':')[1];
    status = returning ? LocalKeys.kReturn : LocalKeys.kReceive;
    updatedObject.transactionNotes = '$quantity:$type:$status';

    return updatedObject;
  }

  /// Store returned laundry objects to in [receivedLaundryBuffer]
  /// This list will be used to upload these objects to the database
  Future<void> returnLaundryItems() async {
    for (OtherTransactions laundryObject in returnedLaundryBuffer.value) {
      laundryObject = updateLaundryStatus(laundryObject,returning: true);
      await OtherTransactionsRepository()
          .updateOtherTransaction(laundryObject.toJson())
          .then((value) async {
        if (value! > 0) {
          UserActivity returnActivity = UserActivity(
            activityId: const Uuid().v1(),
            guestId: metaData.value[LocalKeys.kClientUser].value.clientId,
            roomTransactionId:
                metaData.value[LocalKeys.kRoomTransaction].value.id,
            employeeId: metaData.value[LocalKeys.kLoggedInUser].value.appId,
            employeeFullName:
                metaData.value[LocalKeys.kLoggedInUser].value.fullName,
            activityValue: 0,
            activityStatus: "${LocalKeys.kReturn} ${LocalKeys.kLaundry}",
            description: laundryObject.transactionNotes!.split(":")[1],
            unit: laundryObject.transactionNotes!.split(":")[0],
            dateTime: DateTime.now().toIso8601String(),
          );
          userActivity.value.add(returnActivity);

          await UserActivityRepository()
              .createUserActivity(returnActivity.toJson())
              .then((value) {
            showSnackBar("Returned Laundry", Get.context!);
          });
        } else {
          showSnackBar("FAILED Laundry", Get.context!);
        }
      });
      showSnackBar("${laundryObject.transactionNotes}", Get.context!);
    }
    clearLaundryFormInputs();
    Navigator.of(Get.overlayContext!);
    updateUI();
  }

  receiveLaundry() {
    receivingLaundry.value = true;
    returningLaundry.value = false;
  }

  Future<void> returnLaundry() async {
    receivingLaundry.value = false;
    returningLaundry.value = true;
    await getStoredLaundry();
  }

  clearLaundryFormInputs() {
    laundryQuantityCtrl.clear();
    laundryDescriptionCtrl.clear();
  }
}
