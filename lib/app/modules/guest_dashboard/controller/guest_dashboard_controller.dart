import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/package_form_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/client_user_repo.dart';
import '../../../data/local_storage/repository/room_data_repository.dart';
import '../../../data/local_storage/repository/room_status_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../data/models_n/client_user_model.dart';
import '../../../data/models_n/room_data_model.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../widgets/app_forms/dialog_forms.dart';

class GuestDashboardController extends GetxController{
  Logger logger = AppLogger.instance.logger;
  PaymentDataController paymentDataController = Get.put(PaymentDataController());
  RoomData roomData = Get.find<HomepageController>().selectedRoomData.value;
  Rx<RoomData> selectedRoom = Rx<RoomData>(RoomData());
  Rx<AdminUser> loggedInUser = Get.find<AuthController>().adminUser;
  Rx<ClientUser> clientUser = Rx<ClientUser>(ClientUser());

  Rx<Map<String,dynamic>>  metaData = Rx<Map<String,dynamic>>({});

  Rx<List<UserActivity>> userActivity = Rx<List<UserActivity>>([]);

  Rx<int> userActivityCount = Rx<int>(0);

  Rx<String> checkInDate = "".obs;
  Rx<String> checkOutDate = "".obs;
  Rx<bool> isLoadingData = true.obs;
  bool isTest;

  GuestDashboardController({this.isTest = true});




  @override
  Future<void> onInit() async {

    selectedRoom.value = await RoomDataRepository().getRoom(roomData.roomNumber ?? 0);
    logger.wtf({'Initiating Guest Dashboard': selectedRoom.value.toJson(),'roomStatus': selectedRoom.value.roomStatus!.description});
    if(selectedRoom.value.roomStatus!.description == LocalKeys.kOccupied){
      await getClientData();
      await initializeMetaData();
      // initializeDependencies();
      updateUI();

    }
    isLoadingData.value = false;
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    //paymentController.calculateAllFees();
    updateUI();

  }

  @override
  void dispose(){
    //print('Room Details Disposed');
    super.dispose();
  }



  Future<void> initializeMetaData()async{
      metaData.value = {
      LocalKeys.kLoggedInUser: loggedInUser,
      LocalKeys.kSelectedRoom : selectedRoom.value,
      LocalKeys.kRoomTransaction: paymentDataController.roomTransaction,
      LocalKeys.kClientUser : clientUser
      };
      metaData.refresh();
  }

  void updateUI(){
    userActivityCount.value = userActivity.value.length;
    userActivity.refresh();
  }

  void parseCheckInOutDate(){
    checkInDate.value = extractDate(DateTime.parse(paymentDataController.roomTransaction.value.checkInDate!));
    checkOutDate.value = extractDate(DateTime.parse(paymentDataController.roomTransaction.value.checkOutDate!));
  }

  Future<void> checkOutGuest()async{
    if(paymentDataController.roomTransaction.value.outstandingBalance == 0){
      /// Update RoomTransaction in RoomData
      selectedRoom.value.roomStatus!.description = LocalKeys.kAvailable;
      selectedRoom.value.roomStatus!.code = LocalKeys.kStatusCode100.toString();
      selectedRoom.value.currentTransactionId = "";
      await RoomDataRepository().updateRoom(selectedRoom.toJson()).then((value) async{
        // showSnackBar("UpdatedRoom", Get.context!);
        /// Update RoomStatus
        await RoomStatusRepository().updateRoomStatus(selectedRoom.value.roomStatus!.toJson()).then((value) async{
          // showSnackBar("UpdatedRoomStatus", Get.context!);
          /// Create Admin and Client Activity
          await UserActivityRepository().createUserActivity(
              UserActivity(
                activityId: const Uuid().v1(),
                roomTransactionId: paymentDataController.roomTransaction.value.id,
                guestId: clientUser.value.clientId,
                employeeId: loggedInUser.value.appId,
                employeeFullName: loggedInUser.value.fullName,
                description: LocalKeys.kCheckout.capitalize,
                activityValue: 0,
                unit: LocalKeys.kRoom.capitalize,
                dateTime: DateTime.now().toIso8601String(),
              ).toJson()
          ).then((value) {
            // showSnackBar("Created AdminActivity", Get.context!);
            if(isTest==false) Get.find<HomepageController>().onInit();

          }).then((value) {
            if(isTest==false) Navigator.of(Get.overlayContext!).pop();
          });
        });
      });
    }else{
      if(isTest==false) actionsDialogForms(context: Get.context!, formName: LocalKeys.kCollectPayment);
    }
  }

  Future<void> getClientData()async{
    /// RoomTransaction, ClientUser,  UserActivity, & OtherActivity
    await getRoomTransactionId().then((value)async {
      await getClientUser().then((value) async{
        await getUserActivity();
      });
    });
    parseCheckInOutDate();
    updateUI();
  }

  Future<void> getRoomTransactionId()async{
    await RoomTransactionRepository().getRoomTransaction(selectedRoom.value.currentTransactionId!).then((response) {
      if(response!.isNotEmpty){
        paymentDataController.roomTransaction.value = RoomTransaction.fromJson(response[0]);

        //showSnackBar("Fetched RoomTransaction", Get.context!);
      }else{
        // showSnackBar("FAILED TO FETCH RoomTransaction", Get.context!);
      }
    });
  }

  Future<void> getClientUser()async{
    await ClientUserRepository().getClientUser(paymentDataController.roomTransaction.value.clientId!).then((response) {
      if(response!.isNotEmpty){
        clientUser.value = ClientUser.fromJson(response[0]);
        clientUser.refresh();
        // showSnackBar("Fetched ClientUser ${clientUser.value.fullName}", Get.context!);
      }else{
        // showSnackBar("FAILED TO FETCH clientUser", Get.context!);
      }
    });
  }

  Future<void> getUserActivity()async{
    logger.i({'user':clientUser.value.clientId!, 'roomTR':paymentDataController.roomTransaction.value.id!});
    userActivity.value.clear();
    await UserActivityRepository().getUserActivity(paymentDataController.roomTransaction.value.id!).then((response) {
          if(response != null) {
            for (Map<String, dynamic> element in response) {
              userActivity.value.add(UserActivity.fromJson(element));
            }
            // showSnackBar("Fetched UserActivity", Get.context!);
          }else{
            showSnackBar("FAILED TO FETCH UserActivity", Get.context!);
          }
    });
  }

  Future<void> receiveRoomKey()async{
    UserActivity receiveKeyActivity = UserActivity(
      activityId: const Uuid().v1(),
      guestId: clientUser.value.clientId,
      employeeId: loggedInUser.value.appId,
      employeeFullName: loggedInUser.value.fullName,
      roomTransactionId: paymentDataController.roomTransaction.value.id,
      description: LocalKeys.kSubmitKey,
      unit: LocalKeys.kKey.capitalize,
      activityValue: 0,
      dateTime: DateTime.now().toIso8601String(),
    );

    /// Record UserActivity
    await UserActivityRepository().createUserActivity(
        receiveKeyActivity.toJson()
    ).then((value) {
      userActivity.value.add(receiveKeyActivity);
      updateUI();
      // showSnackBar("RECEIVED KEY", Get.context!);
    });
  }

  Future<void> returnRoomKey()async{
    UserActivity returnKeyActivity = UserActivity(
      activityId: const Uuid().v1(),
      guestId: clientUser.value.clientId,
      employeeId: loggedInUser.value.appId,
      employeeFullName: loggedInUser.value.fullName,
      roomTransactionId: paymentDataController.roomTransaction.value.id,
      description: LocalKeys.kRetrieveKey,
      unit: LocalKeys.kKey.capitalize,
      activityValue: 0,
      dateTime: DateTime.now().toIso8601String(),
    );
    /// Record UserActivity
    await UserActivityRepository().createUserActivity(
        returnKeyActivity.toJson()
    ).then((value) {
      userActivity.value.add(returnKeyActivity);
      updateUI();
      // showSnackBar("RETURNED KEY", Get.context!);
    });
  }

}