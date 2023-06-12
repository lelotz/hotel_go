import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_data_controller.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/services/calulators/stay_calculator.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
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
  HomepageController homepageController = Get.find<HomepageController>();
  RoomData roomData = Get.find<HomepageController>().selectedRoomData.value;
  Rx<RoomData> selectedRoom = Rx<RoomData>(RoomData());
  Rx<AdminUser> loggedInUser = Get.find<AuthController>().adminUser;
  Rx<ClientUser> clientUser = Rx<ClientUser>(ClientUser());

  Rx<Map<String,dynamic>>  metaData = Rx<Map<String,dynamic>>({});

  Rx<List<UserActivity>> userActivity = Rx<List<UserActivity>>([]);
  Rx<bool> fetchingUserActivity = false.obs;

  Rx<int> userActivityCount = Rx<int>(0);
  Rx<String> selectedForm = "".obs;
  Rx<String> checkInDate = "".obs;
  Rx<String> checkOutDate = "".obs;
  Rx<bool> isLoadingData = true.obs;
  Rx<bool> isCheckedOut = false.obs;
  Rx<bool> isSettingRoomToAvailable = false.obs;

  Rx<bool> housekeeperAssigned = false.obs;


  bool isTest;
  Rx<List<AdminUser>> houseKeepingStaff = Rx<List<AdminUser>>([]);
  Rx<AdminUser> selectedHouseKeeper = Rx<AdminUser>(AdminUser());
  Rx<List<String>> houseKeepingStaffNames = Rx<List<String>>([]);
  Rx<String> selectedHouseKeeperName = Rx<String>('');
  late StayCalculator stayCalculator;

  GuestDashboardController({this.isTest = false});




  @override
  Future<void> onInit() async {
    super.onInit();
    selectedRoom.value = await RoomDataRepository().getRoom(roomData.roomNumber ?? 0);
    stayCalculator = StayCalculator(roomData: selectedRoom.value,roomTransactionId: selectedRoom.value.currentTransactionId!);
    logger.wtf({'Initiating Guest Dashboard': selectedRoom.value.toJson(),'roomStatus': selectedRoom.value.roomStatus!.description});
    if(selectedRoom.value.roomStatus!.description == LocalKeys.kOccupied){
      isCheckedOut.value = false;
      await getClientData();
      await initializeMetaData();
      updateUI();

    }else if (selectedRoom.value.roomStatus!.description == LocalKeys.kHouseKeeping){
      isCheckedOut.value = true;
      await getClientData();
      await initializeMetaData();
      updateUI();
      await getHouseKeepingStaff();
      if(selectedHouseKeeperName.value!='') housekeeperAssigned.value = true;
    }
    isLoadingData.value = false;

  }

  @override
  onReady() {
    super.onReady();
    //paymentController.calculateAllFees();
    updateUI();

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
   // userActivity.value = userActivity.value.reversed.toList();
  }

  selectHouseKeeper(String houseKeeper) {
    selectedHouseKeeperName.value = houseKeeper;
    selectedHouseKeeper.refresh();
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

  setSelectedHouseKeeperModel()async{
    await AdminUserRepository().getAdminUserByName(selectedHouseKeeperName.value).then((value) {
      selectedHouseKeeper.value = value!;
    });
  }

    Future<void> extendGuestStay(DateTime? newCheckOutDate)async{
    RoomTransaction? roomTransaction;
    roomTransaction = await RoomTransactionRepository().getRoomTransaction(selectedRoom.value.currentTransactionId!);

    await stayCalculator.updateStayCostByCheckOutDate(newCheckOutDate!.toIso8601String(), roomTransaction);
    await paymentDataController.getCurrentRoomTransaction();
    paymentDataController.update();
    parseCheckInOutDate();
    await getUserActivity();


  }

  assignHouseKeeperRoomToClean()async{
    await setSelectedHouseKeeperModel();
    await UserActivityRepository().createUserActivity(
        UserActivity(
          activityId: Uuid().v1(),
          activityValue: 0,
          activityStatus: LocalKeys.kHouseKeeping,
          employeeFullName: selectedHouseKeeperName.value,
          guestId: clientUser.value.clientId,
          roomTransactionId: roomData.currentTransactionId,
          employeeId: loggedInUser.value.id,
          description: LocalKeys.kHouseKeeping,
          unit: selectedRoom.value.roomNumber.toString(),
          dateTime: DateTime.now().toIso8601String()
        ).toJson()
    );
    selectedHouseKeeper.value = AdminUser.incrementRoomsSold(selectedHouseKeeper.value.toJson());
    await AdminUserRepository().updateAdminUser(selectedHouseKeeper.value.toJson());
    await getHouseKeepingUserActivity();
    housekeeperAssigned.value = true;
  }

  getHouseKeepingUserActivity()async{
    userActivity.value.clear();
    userActivity.value = await UserActivityRepository().getUserActivityByRoomTransactionIdAndDescription(
        roomData.currentTransactionId!,LocalKeys.kHouseKeeping);
    getAssignedHousekeeperByRoomNumber();
    updateUI();
  }

  getAssignedHousekeeperByRoomNumber(){
    for(UserActivity housekeepingActivity in userActivity.value){
      if(housekeepingActivity.roomTransactionId == roomData.currentTransactionId){
        selectedHouseKeeperName.value = housekeepingActivity.employeeFullName!;
      }
    }
  }

  void parseCheckInOutDate(){
    checkInDate.value = extractDate(DateTime.parse(paymentDataController.roomTransaction.value.checkInDate!));
    checkOutDate.value = extractDate(DateTime.parse(paymentDataController.roomTransaction.value.checkOutDate!));
  }

  openDashboardForm(String formName){
    actionsDialogForms(context:Get.context!, formName:formName,
        height: formName == LocalKeys.kCollectPayment ? 575 : 900);
        // width: formName == LocalKeys.kCollectPayment ? 900 : 550,);
  }

  Future<void> checkOutGuest()async{
    if(paymentDataController.roomTransaction.value.outstandingBalance == 0){
      /// Update RoomTransaction in RoomData
      selectedRoom.value.roomStatus!.description = LocalKeys.kHouseKeeping;
      selectedRoom.value.roomStatus!.code = LocalKeys.kStatusCode150.toString();
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
                employeeId: loggedInUser.value.id,
                employeeFullName: loggedInUser.value.fullName,
                description: LocalKeys.kCheckout.capitalize,
                activityValue: 0,
                unit: LocalKeys.kRoom.capitalize,
                dateTime: DateTime.now().toIso8601String(),
              ).toJson()
          ).then((value) async{
            isCheckedOut.value = false;
            isCheckedOut.refresh();
            await onInit();
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
        isCheckedOut.value ? await getHouseKeepingUserActivity() : await getUserActivity();
      });
    });
    parseCheckInOutDate();
    updateUI();
  }

  setRoomAsAvailable()async{
    selectedRoom.value.roomStatus!.description = LocalKeys.kAvailable;
    selectedRoom.value.roomStatus!.code = LocalKeys.kStatusCode100.toString();
    selectedRoom.value.currentTransactionId = "";

    await RoomDataRepository().updateRoom(selectedRoom.toJson()).then((value) async {
      /// Update RoomStatus
      await RoomStatusRepository().updateRoomStatus(
          selectedRoom.value.roomStatus!.toJson());
    });
    isSettingRoomToAvailable.value = false;


  }

  Future<void> getRoomTransactionId()async{
    paymentDataController.roomTransaction.value = await RoomTransactionRepository().
    getRoomTransaction(selectedRoom.value.currentTransactionId!);
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
    fetchingUserActivity.value = true;
    logger.i({'user':clientUser.value.clientId!, 'roomTR':paymentDataController.roomTransaction.value.id!});
    userActivity.value.clear();
    await UserActivityRepository().getUserActivity(paymentDataController.roomTransaction.value.id!).then((response) {
          if(response != null) {
            for (Map<String, dynamic> element in response) {

              userActivity.value.add(UserActivity.fromJson(element));
             //  userActivity.value = userActivity.value.reversed.toList();

              userActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
            }
          }
      });
    updateUI();
   // await Future.delayed(Duration(seconds: 3));
    fetchingUserActivity.value = false;

  }

  Future<void> receiveRoomKey()async{
    UserActivity receiveKeyActivity = UserActivity(
      activityId: const Uuid().v1(),
      guestId: clientUser.value.clientId,
      employeeId: loggedInUser.value.id,
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
      userActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));

      updateUI();
      // showSnackBar("RECEIVED KEY", Get.context!);
    });
  }

  List<UserActivity> sortUserActivity(List<UserActivity> userActivity){
    List<UserActivity> sortedActivity = [];
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().add(Duration(days: -1));
    
    now.millisecondsSinceEpoch.compareTo(yesterday.millisecondsSinceEpoch);




    return sortedActivity;
  }

  Future<void> returnRoomKey()async{
    UserActivity returnKeyActivity = UserActivity(
      activityId: const Uuid().v1(),
      guestId: clientUser.value.clientId,
      employeeId: loggedInUser.value.id,
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
      userActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
      updateUI();
      // showSnackBar("RETURNED KEY", Get.context!);
    });
  }

}