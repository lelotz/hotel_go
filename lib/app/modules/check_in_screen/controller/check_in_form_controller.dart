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
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
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


  HomepageController? homepageController;
  Rx<RoomData> selectedRoomData = Rx<RoomData>(RoomData());
  String employeeId = Get.find<AuthController>().adminUser.value.appId!;
  String employeeName = Get.find<AuthController>().adminUser.value.fullName!;

  String userId = const Uuid().v1();
  String transactionId = const Uuid().v1();

  Rx<int> roomCost = Rx<int>(0);
  Rx<int> outstandingBalance = Rx<int>(0);
  bool isReport;
  String roomNumber;

  CheckInFormController({this.isReport = false,this.roomNumber = "101"});

  @override
  onInit()async{
    super.onInit();
    adultsCtrl.text = "1";
    childrenCtrl.text = "0";
    fullNameCtrl.text = mockNames[random(0,mockNames.length)];
    goingToCtrl.text = mockCountries[random(0, mockCountries.length)];
    comingFromCtrl.text = mockCountries[random(0, mockCountries.length)];
    idNumberCtrl.text = random(111111, 9999999).toString();
    idTypeCtrl.text = "PASSPORT";
    countryOfBirthCtrl.text = mockCountries[random(0, mockCountries.length)];
    nightsCtrl.text = "1";
    paidTodayCtrl.text = "0";
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
      logger.i({'roomData': selectedRoomData.value});


    }

  }

  stayCost(){
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType['VIP'] : AppConstants.roomType['STD'];
    roomCost.value = (stringToInt(nightsCtrl.text) ?? 0) * roomPrice;
    //roomCost.value = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType['VIP'] : AppConstants.roomType['STD'];
    checkOutDate.value.add(Duration(days: stringToInt(nightsCtrl.text)));
    roomCost.refresh();
    update();
  }

  calculateOutstandingBalance (){
    outstandingBalance.value = roomCost.value - (stringToInt(paidTodayCtrl.text));
  }

  checkInGuest()async {
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType[LocalKeys.kVip] : AppConstants.roomType[LocalKeys.kStd];

    roomCost.value = stringToInt(nightsCtrl.text) * roomPrice;
    paidTodayCtrl.text = roomCost.value.toString();
    outstandingBalance.value = roomCost.value - stringToInt(paidTodayCtrl.text);

    await createClientProfile().then((value) async{
      showSnackBar("Created Profile", Get.context!);
        await createRoomTransaction().then((value) async{
          showSnackBar("Created Transaction", Get.context!);
          await updateRoomData().then((value)async {
            showSnackBar("Updated RoomsStatus", Get.context!);
            await updateAdminUserRoomsSold().then((value) {
              showSnackBar("Updated Rooms Sold", Get.context!);
            }).then((value) async {
              await createClientActivity().then((value) {
                showSnackBar("Created ClientActivity", Get.context!);
              }).then((value) async{
                if(int.tryParse(paidTodayCtrl.text) != null && int.tryParse(paidTodayCtrl.text) != 0){
                  await CollectPayment(
                    id: const Uuid().v1(),
                    employeeId: employeeId,
                    employeeName: employeeName,
                    roomTransactionId: transactionId,
                    clientId: userId,
                    clientName: fullNameCtrl.text,
                    service: LocalKeys.kRoom,
                    roomNumber: selectedRoomData.value.roomNumber,
                    amountCollected: int.tryParse(paidTodayCtrl.text),
                    dateTime: DateTime.now().add(Duration(days: dayOffset)).toIso8601String(),
                    date: extractDate(DateTime.now().add(Duration(days: dayOffset))),
                    time: extractTime(DateTime.now()),
                    payMethod: "CASH",
                    receiptNumber: const Uuid().v1(),
                  ).toDb().then((value) async{
                    await homepageController?.refreshSelectedRoom();
                    if(isReport)  await Get.find<HandoverFormController>().onInit();
                    showSnackBar("Created CollectPayment", Get.context!);
                  });
                }
                //update();
              });
            });
          });
        });
      });

  }
  Future<void> createClientProfile()async{
    await ClientUserRepository().createClientUser(
        ClientUser(
            clientId: userId,
            fullName: fullNameCtrl.text,
            idType: idTypeCtrl.text,
            idNumber: idNumberCtrl.text,
            countryOfBirth: countryOfBirthCtrl.text
        ).toJson());
  }
  Future<void> createRoomTransaction()async {
    await RoomTransactionRepository().createRoomTransaction(
        RoomTransaction(
          id: transactionId,
          clientId: userId,
          employeeId: employeeId,
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
        ).toJson()
    );
  }
  Future<void> updateRoomData()async{
    selectedRoomData.value.currentTransactionId = transactionId;
    selectedRoomData.value.roomStatus!.description = LocalKeys.kOccupied;
    selectedRoomData.value.roomStatus!.code =  LocalKeys.kStatusCode200.toString();
    selectedRoomData.value.nextAvailableDate = checkOutDate.value.toIso8601String();
    await RoomDataRepository().updateRoom(selectedRoomData.value.toJson()).then((value) async {
      showSnackBar("Updated RoomsData", Get.context!);
      await RoomStatusRepository().updateRoomStatus(selectedRoomData.value.roomStatus!.toJson());
    });
  }
  Future<void> updateAdminUserRoomsSold()async{
    AdminUser aU = Get.find<AuthController>().adminUser.value;
    await AdminUserRepository().updateAdminUser(AdminUser.incrementRoomsSold(aU.toJson()).toJson());
  }
  Future<void> createClientActivity()async {
    await UserActivityRepository().createUserActivity(
      UserActivity(
        activityId: const Uuid().v1(),
        guestId: userId,
        roomTransactionId: transactionId,
        employeeId: employeeId,
        employeeFullName: Get.find<AuthController>().adminUser.value.fullName,
        activityValue: roomCost.value,
        activityStatus: LocalKeys.kCheckIn.capitalize,
        description: LocalKeys.kCheckIn.capitalize,
        unit: LocalKeys.kRoom.capitalize,
        dateTime: DateTime.now().toIso8601String()
      ).toJson()
    );
  }

}