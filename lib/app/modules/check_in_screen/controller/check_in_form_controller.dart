import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/client_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/core/values/localization/messages.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/client_user_repo.dart';
import '../../../data/local_storage/repository/room_data_repository.dart';
import '../../../data/local_storage/repository/room_status_repo.dart';
import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../data/models_n/room_data_model.dart';
import '../../homepage_screen/controller/homepage_controller.dart';
import '../../sales_module/controller/sales_controller.dart';

class CheckInFormController extends GetxController{
  Logger logger = AppLogger.instance.logger;
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController nightsCtrl = TextEditingController();
  TextEditingController adultsCtrl = TextEditingController();
  TextEditingController childrenCtrl = TextEditingController();
  TextEditingController goingToCtrl = TextEditingController();
  TextEditingController comingFromCtrl = TextEditingController();
  TextEditingController idTypeCtrl = TextEditingController();
  TextEditingController idNumberCtrl = TextEditingController();
  TextEditingController paidTodayCtrl = TextEditingController();
  TextEditingController countryOfBirthCtrl = TextEditingController();
  Rx<DateTime> checkInDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime> checkOutDate = Rx<DateTime>(DateTime.now());
  Map<String,dynamic> checkInArtifacts = {};

  HomepageController? homepageController;
  Rx<RoomData> selectedRoomData = Rx<RoomData>(RoomData());
  Future<String> get employeeId async => Get.find<AuthController>().adminUser.value.appId!;
  Future<String> get employeeIdName async => Get.find<AuthController>().adminUser.value.fullName!;

  Rx<String> payMethod = Rx<String>('');
  Rx<String> payMethodStatus = Rx<String>('');
  String userId = const Uuid().v1();
  final String transactionId = const Uuid().v1();

  Rx<int> roomCost = Rx<int>(0);
  Rx<int> outstandingBalance = Rx<int>(0);
  bool isReport;
  bool isTest;

  String roomNumber;

  CheckInFormController({this.isReport = false,this.roomNumber = "101",this.isTest=false});

  @override
  Future<void> onInit()async{
    super.onInit();
    adultsCtrl.text = "1";
    childrenCtrl.text = "0";
    nightsCtrl.text = "1";
    paidTodayCtrl.text = "0";
    // fullNameCtrl.text = mockNames[mockNameIndex];
    // goingToCtrl.text = mockCountries[mockCountriesIndex].split(' ')[1];
    // comingFromCtrl.text = mockCountries[random(0, mockCountries.length)].split(' ')[1];
    // idNumberCtrl.text = random(111111, 9999999).toString();
    // idTypeCtrl.text = "PASSPORT";
    // countryOfBirthCtrl.text = mockCountries[mockCountriesIndex];

    await initializeRoomData(roomNumber);
    stayCost();
    outstandingBalance();
  }

  Future<void> initializeRoomData(String roomNumber)async{
    if(isReport==false){
      homepageController = Get.find<HomepageController>();
      await homepageController?.refreshSelectedRoom();
      selectedRoomData.value = homepageController!.selectedRoomData.value;
    }else{
      await RoomDataRepository().getRoom(int.parse(roomNumber)).then((value) async{
        selectedRoomData.value = value;
        await RoomStatusRepository().getRoomsStatus(selectedRoomData.value.roomNumber!).then((value) {
          if(value != null )selectedRoomData.value.roomStatus = RoomStatusModel.fromJson(value[0]);
        });
      });
      //logger.i({'roomData': selectedRoomData.value});


    }

  }

  bool validatePayMethod(){
    // bookingInitiated.value = true;

    if(payMethod.value == ''){
      payMethodStatus.value = 'Pay Method ${AppMessages.isNotEmpty}';
      // bookingInitiated.value = false;
      return false;
    }else{
      payMethodStatus.value = '';
    }
    // bookingInitiated.value = false;
    return true;
  }
  setPayMethod(String method){
    payMethod.value = method;
    payMethod.refresh();
  }
  stayCost(){
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType['VIP'] : AppConstants.roomType['STD'];
    roomCost.value = (stringToInt(nightsCtrl.text) ) * roomPrice;
    //roomCost.value = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType['VIP'] : AppConstants.roomType['STD'];
    checkOutDate.value.add(Duration(days: stringToInt(nightsCtrl.text)));
    roomCost.refresh();
    update();
  }

  calculateOutstandingBalance (){
    if(stringToInt(paidTodayCtrl.value.text) > -1 && stringToInt(paidTodayCtrl.value.text) <= roomCost.value){
      outstandingBalance.value = roomCost.value - (stringToInt(paidTodayCtrl.text));
    }

  }

  checkInFormIsValid(){

  }


  validateNightsStay(){
    if(nightsCtrl.text.isNumericOnly == false){
      return AppMessages.numericOnly.tr;
    }

    return null;
  }

  checkInGuest()async {
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType[LocalKeys.kVip] : AppConstants.roomType[LocalKeys.kStd];

    roomCost.value = stringToInt(nightsCtrl.text) * roomPrice;
    if(isTest == false){
      paidTodayCtrl.text = roomCost.value.toString();
    }
    outstandingBalance.value = roomCost.value - stringToInt(paidTodayCtrl.text);

    await createClientProfile().then((value) async{
      //showSnackBar("Created Profile", Get.context!);
        await createRoomTransaction().then((value) async{
          //showSnackBar("Created Transaction", Get.context!);
          await updateRoomData().then((value)async {
           // showSnackBar("Updated RoomsStatus", Get.context!);
            await updateAdminUserRoomsSold().then((value) {
              //showSnackBar("Updated Rooms Sold", Get.context!);
            }).then((value) async {
              await createClientActivity().then((value) {
               // showSnackBar("Created ClientActivity", Get.context!);
              }).then((value) async{
                if(int.tryParse(paidTodayCtrl.text) != null && int.tryParse(paidTodayCtrl.text) != 0){
                  final String collectPaymentId = const Uuid().v1();
                  CollectPayment collectPayment = CollectPayment(
                    id: collectPaymentId,
                    employeeId: await employeeId,
                    employeeName: await employeeIdName,
                    roomTransactionId: transactionId,
                    clientId: userId,
                    clientName: fullNameCtrl.text,
                    service: LocalKeys.kRoom,
                    roomNumber: selectedRoomData.value.roomNumber,
                    amountCollected: int.tryParse(paidTodayCtrl.text),
                    dateTime: DateTime.now().add(Duration(days: dayOffset)).toIso8601String(),
                    date: extractDate(DateTime.now().add(Duration(days: dayOffset))),
                    time: extractTime(DateTime.now()),
                    payMethod: payMethod.value,
                    receiptNumber: const Uuid().v1(),
                  );
                  await collectPayment.toDb().then((value) async{
                    await homepageController?.refreshSelectedRoom();
                    checkInArtifacts[CheckInArtifactsKeys.collectedPaymentId] = collectPaymentId;
                    checkInArtifacts['${CheckInArtifactsKeys.collectedPaymentId}value'] = collectPayment.toJson();
                    if(isReport && isTest == false)  await Get.find<ReportGeneratorController>().onInit();
                    //showSnackBar("Created CollectPayment", Get.context!);
                  });
                }

              });
            });
          });
        });
      });

  }
  Future<void> createClientProfile()async{
    ClientUser clientUser = ClientUser(
        clientId: userId,
        fullName: fullNameCtrl.text,
        idType: idTypeCtrl.text,
        idNumber: idNumberCtrl.text,
        countryOfBirth: countryOfBirthCtrl.text
    );
    await ClientUserRepository().createClientUser(
        clientUser.toJson()).then((value) {
          checkInArtifacts[CheckInArtifactsKeys.clientId] = userId;
          checkInArtifacts['${CheckInArtifactsKeys.clientId}value'] = clientUser.toJson();
    });
  }
  Future<void> createRoomTransaction()async {
    RoomTransaction roomTransaction = RoomTransaction(
      id: transactionId,
      clientId: userId,
      employeeId: await employeeId,
      checkOutDate: checkOutDate.value.toIso8601String(),
      checkInDate: checkInDate.value.toIso8601String(),
      arrivingFrom: comingFromCtrl.text,
      goingTo: goingToCtrl.text,
      roomNumber: selectedRoomData.value.roomNumber,
      nights: stringToInt(nightsCtrl.text),
      roomCost: roomCost.value,
      roomAmountPaid: int.tryParse(paidTodayCtrl.text),
      roomOutstandingBalance: outstandingBalance.value,
      otherCosts: 0,
      grandTotal: roomCost.value,
      outstandingBalance: roomCost.value - int.tryParse(paidTodayCtrl.text)!,
      amountPaid: int.tryParse(paidTodayCtrl.text),
      paymentNotes: outstandingBalance.value != 0 ? LocalKeys.kRequestedPaymentAtCheckOut : "",
      transactionNotes: '',
      date: DateTime.now().toIso8601String(),
      time: extractTime(DateTime.now()),
    );
    await RoomTransactionRepository().createRoomTransaction(roomTransaction.toJson()).then((value) {
      checkInArtifacts[CheckInArtifactsKeys.roomTransactions] = roomTransaction.id;
      checkInArtifacts['${CheckInArtifactsKeys.roomTransactions}value'] = roomTransaction.toJson();
    });
  }
  Future<void> updateRoomData()async{
    selectedRoomData.value.currentTransactionId = transactionId;
    selectedRoomData.value.roomStatus!.description = LocalKeys.kOccupied;
    selectedRoomData.value.roomStatus!.code =  LocalKeys.kStatusCode200.toString();
    selectedRoomData.value.nextAvailableDate = checkOutDate.value.toIso8601String();
    await RoomDataRepository().updateRoom(selectedRoomData.value.toJson()).then((value) async {
      await RoomStatusRepository().updateRoomStatus(selectedRoomData.value.roomStatus!.toJson()).then((value) {
      });
    });
    logger.i({'currentTID':selectedRoomData.value.toJson()});
    checkInArtifacts[CheckInArtifactsKeys.roomData] = selectedRoomData.value.roomNumber;
    checkInArtifacts['${CheckInArtifactsKeys.roomData}value'] = selectedRoomData.value.toJson();
  }
  Future<void> updateAdminUserRoomsSold()async{
    await Get.find<AuthController>().updateAdminUser();
    AdminUser aU = Get.find<AuthController>().adminUser.value;
    await AdminUserRepository().getAdminUserById(await employeeId).then((value) {
      aU = AdminUser().fromJsonList(value ?? [])[0];
    });

    //logger.i({'updateAdminUserFromAuth': aU.appId});
    aU = AdminUser.incrementRoomsSold(aU.toJson());
    await AdminUserRepository().updateAdminUser(aU.toJson()).then((value) {
      checkInArtifacts[CheckInArtifactsKeys.employeeId] = aU.appId;
      checkInArtifacts['${CheckInArtifactsKeys.employeeId}value'] = aU.toJson();
    });
    await Get.find<AuthController>().updateAdminUser();
  }
  Future<void> createClientActivity()async {
    final String activityId = const Uuid().v1();
    UserActivity userActivity = UserActivity(
        activityId: activityId,
        guestId: userId,
        roomTransactionId: transactionId,
        employeeId: await employeeId,
        employeeFullName: await employeeIdName,
        activityValue: roomCost.value,
        activityStatus: LocalKeys.kCheckIn.capitalize,
        description: LocalKeys.kCheckIn.capitalize,
        unit: LocalKeys.kRoom.capitalize,
        dateTime: DateTime.now().toIso8601String()
    );
    await UserActivityRepository().createUserActivity(userActivity.toJson()).then((value) {
      checkInArtifacts[CheckInArtifactsKeys.clientActivity] = activityId;
      checkInArtifacts['${CheckInArtifactsKeys.clientActivity}value'] = userActivity.toJson();
    });
  }

}