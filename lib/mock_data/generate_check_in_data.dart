
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/client_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:uuid/uuid.dart';

import '../app/data/local_storage/repository/admin_user_repo.dart';
import '../app/data/local_storage/repository/client_user_repo.dart';
import '../app/data/local_storage/repository/room_data_repository.dart';
import '../app/data/local_storage/repository/room_status_repo.dart';
import '../app/data/local_storage/repository/room_transaction_repo.dart';
import '../app/data/local_storage/repository/session_management_repo.dart';
import '../app/data/local_storage/repository/user_activity_repo.dart';
import '../app/data/models_n/room_data_model.dart';
import '../app/data/models_n/session_tracker.dart';
import '../core/session_management/session_manager.dart';
import '../core/utils/useful_math.dart';

class CheckInFormGenerator extends GetxController{
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

  AdminUser? currentAdmin;
  ClientUser? currentClient;

  Rx<List<AdminUser>> employees = Rx<List<AdminUser>>([]);
  String employeeId = "";
  String employeeName = "";

  String clientUserId = const Uuid().v1();
  String transactionId = const Uuid().v1();

  Rx<int> roomCost = Rx<int>(0);
  Rx<int> outstandingBalance = Rx<int>(0);
  Rx<RoomData> selectedRoomData  = Rx<RoomData>(RoomData());
  List<String> idtypes = ["PASSPORT","DRIVING LICENCE","NATIONAL ID","WORK ID"];

  List<int> roomsInBuilding = [101,102,103,104,105,106,107,108,109,110,201,202,203,204,205,206,207,208,209];
  List<int> paymentOffsets = [0,5000,0,0,15000,0,0,0];
  RoomTransaction currentRoomTransaction = RoomTransaction();
  SessionManager sessionController = Get.put(SessionManager(),permanent: true);


  @override
  onInit(){
    adultsCtrl.text = "1";
    childrenCtrl.text = "0";
    fullNameCtrl.text = "Another One";
    goingToCtrl.text = "Nowhere";
    comingFromCtrl.text = "Somewhere";
    idNumberCtrl.text = "23456789";
    idTypeCtrl.text = "PASSPORT";
    countryOfBirthCtrl.text = "Tz";

    nightsCtrl.text = "1";
    paidTodayCtrl.text = "0";
    stayCost();
    outstandingBalance();
    super.onInit();
  }


  int daysOffset = 0;



  prepDataForCheckIn()async{
    int mockDataIndex = 0;
    int employeeIndex = 0;
    int currentRoomNumber = 0;

    await getAllEmployees();

    for (mockDataIndex = 0; mockDataIndex < mockDataCount-1; mockDataIndex++) {

      /// Current Ids
      clientUserId = const Uuid().v1();
      transactionId = const Uuid().v1();
      currentRoomNumber = roomsInBuilding[random(0, roomsInBuilding.length-1)];

      /// Input Values
      nightsCtrl.text = random(1, 5).toString();
      checkInDate.value = DateTime.now().add(Duration(days: daysOffset));
      adultsCtrl.text = random(1, 2).toString();
      fullNameCtrl.text = mockNames [mockDataIndex];
      countryOfBirthCtrl.text = mockCountries[mockDataIndex];
      comingFromCtrl.text = mockCountries[mockDataIndex];
      goingToCtrl.text = "DAR";
      idTypeCtrl.text = idtypes[random(0, idtypes.length - 1)];
      idNumberCtrl.text = random(1000, 99999999).toString();
      /// RoomData
      selectedRoomData.value = RoomData(
          roomNumber: currentRoomNumber,
          isVIP: random(101, 210) >= 200 ? 1 : 0,
          currentTransactionId: transactionId,
          roomStatus: RoomStatusModel(
              roomId: currentRoomNumber,
              code: "200",
              description: LocalKeys.kOccupied.toUpperCase()
          )

      );
      paidTodayCtrl.text =
          (int.parse(nightsCtrl.text) * selectedRoomData.value.roomNumber! >=
              200 ? 35000 : 30000).toString();
      paidTodayCtrl.text = (int.parse(paidTodayCtrl.text) -
          paymentOffsets[random(0,paymentOffsets.length-1)])
          .toString();
      if (mockDataIndex % 19 == 0) daysOffset++;
      logger.i('mockIndex $mockDataIndex');



      /// Current Objects

      /// Employee
      currentAdmin = employees.value[employeeIndex];
      await authenticateAdminUser();
      employeeId = currentAdmin!.appId!;
      employeeName = currentAdmin!.fullName!;

      /// Client
      currentClient = ClientUser(
          clientId: clientUserId,
          fullName: fullNameCtrl.text,
          idType: idTypeCtrl.text,
          idNumber: idNumberCtrl.text,
          countryOfBirth: countryOfBirthCtrl.text
      );

      employeeIndex = random(0, employees.value.length - 1);

      /// Room Transaction
      currentRoomTransaction = RoomTransaction(
        id: transactionId,
        clientId: clientUserId,
        employeeId: employeeId,
        checkOutDate: checkOutDate.value.add(Duration(days: stringToInt(nightsCtrl.text))).toIso8601String(),
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


      await checkInGuest();
      await checkOutGuest();
      await logOutUser();
    }
  }


  manageSession(){}

  Future<bool> authenticateAdminUser()async{
    bool isAuthenticated = false;

    await AdminUserRepository().getAdminUser(currentAdmin!.toJson()).then((value)async {
      if(value!.length == 1){
        currentAdmin = AdminUser.fromJson(value[0]);
        isAuthenticated = true;


        sessionController.createNewSession(
            SessionTracker(
              id: const Uuid().v1(),
              employeeId: currentAdmin!.appId,
              dateCreated: DateTime.now().toIso8601String(),
            ).toJson());

        logger.v("SUCCESS : Log in");

        // await loadMockNamesAndCountries();
        // await CheckInFormGenerator().prepDataForCheckIn();

      }
    });
    return isAuthenticated;
  }

  Future<void> logOutUser()async{

    int? activityStatus = -1;
    int? clearSessionStatus = -1;
    clearSessionStatus = await createLogOutUserActivity();
    activityStatus = await clearUserSession();
    if(activityStatus != null && clearSessionStatus != null && activityStatus > 0 && clearSessionStatus > 0) {
      sessionController.updateSessionTracker();
    }

  }

  Future<int?> clearUserSession()async{
    sessionController.currentSession.value = SessionTracker();
    return await SessionManagementRepository().deleteCurrentSession();
  }

  Future<int?> createLogOutUserActivity()async{
    return await UserActivityRepository().createUserActivity(UserActivity(
      activityId: const Uuid().v1(),
      employeeId: currentAdmin!.appId,
      employeeFullName: currentAdmin!.fullName,
      guestId: '-',
      activityValue: 0,
      unit: 'logOutUser',
      activityStatus: 'LOG-OUT',
      description: 'LOG-OUT',
      dateTime: DateTime.now().toIso8601String(),
    ).toJson());
  }


  getAllEmployees()async{
    await SqlDatabase.instance.read(tableName: AdminUsersTable.tableName,readAll: true).then((value) {
      if(value!=null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          employees.value.add(AdminUser.fromJson(element));
        }
      }
      employees.refresh();
    });
  }

  stayCost(){
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType['VIP'] : AppConstants.roomType['STD'];
    roomCost.value = (stringToInt(paidTodayCtrl.text) ) * roomPrice;
  }

  calculateOutstandingBalance (){
    outstandingBalance.value = roomCost.value - (stringToInt(paidTodayCtrl.text));
  }

  checkInGuest()async {
    int roomPrice = selectedRoomData.value.isVIP == 1 ? AppConstants.roomType[LocalKeys.kVip] : AppConstants.roomType[LocalKeys.kStd];

    roomCost.value = (stringToInt(paidTodayCtrl.text)) * roomPrice;
    outstandingBalance.value = roomCost.value - (stringToInt(paidTodayCtrl.text));

    await createClientProfile().then((value) async{
      //showSnackBar("Created Profile", Get.context!);
      await createRoomTransaction().then((value) async{
        //showSnackBar("Created Transaction", Get.context!);
        await updateRoomData().then((value)async {
          //showSnackBar("Updated RoomsStatus", Get.context!);
          await updateAdminUserRoomsSold().then((value) {
            //showSnackBar("Updated Rooms Sold", Get.context!);
          }).then((value) async {
            await createClientActivity().then((value) {
              //showSnackBar("Created ClientActivity", Get.context!);
            }).then((value) async{

              if(int.tryParse(paidTodayCtrl.text) != null && int.tryParse(paidTodayCtrl.text) != 0){
                await CollectPayment(
                  id: const Uuid().v1(),
                  employeeId: currentAdmin!.appId,
                  employeeName: currentAdmin!.fullName,
                  roomTransactionId: transactionId,
                  clientId: clientUserId,
                  clientName: fullNameCtrl.text,
                  service: LocalKeys.kRoom,
                  roomNumber: selectedRoomData.value.roomNumber,
                  amountCollected: int.tryParse(paidTodayCtrl.text),
                  dateTime: checkInDate.value.toIso8601String(),
                  date: extractDate(checkInDate.value),
                  time: extractTime(checkInDate.value),
                  payMethod: "CASH",
                  receiptNumber: const Uuid().v1(),
                ).toDb().then((value) {
                  logger.i("SUCCESS CREATED CHECK-IN");
                });

                //Get.to(()=> const RoomDetailsView());
              }
            });
          });
        });
      });
    });

  }

  Future<void> checkOutGuest()async{
    if(currentRoomTransaction.outstandingBalance == 0){
      /// Update RoomTransaction in RoomData
      selectedRoomData.value.roomStatus!.description = LocalKeys.kAvailable;
      selectedRoomData.value.roomStatus!.code = LocalKeys.kStatusCode100.toString();
      selectedRoomData.value.currentTransactionId = "";
      await RoomDataRepository().updateRoom(selectedRoomData.value.toJson()).then((value) async{
        /// Update RoomStatus
        await RoomStatusRepository().updateRoomStatus(selectedRoomData.value.roomStatus!.toJson()).then((value) async{
          /// Create Admin and Client Activity
          await UserActivityRepository().createUserActivity(
              UserActivity(
                activityId: const Uuid().v1(),
                roomTransactionId: currentRoomTransaction.id,
                guestId: currentClient!.clientId,
                employeeId: currentAdmin!.appId,
                employeeFullName: currentAdmin!.fullName,
                description: LocalKeys.kCheckout.capitalize,
                activityValue: 0,
                unit: LocalKeys.kRoom.capitalize,
                dateTime: checkOutDate.value.toIso8601String(),
              ).toJson()
          );
        });
      });
    }else{
      /// CollectPayment
      // actionsDialogForms(context: Get.context!, formName: LocalKeys.kCollectPayment);
    }
  }

  Future<void> createClientProfile()async{
    await ClientUserRepository().createClientUser(
        currentClient!.toJson());
  }
  Future<void> createRoomTransaction()async {
    await RoomTransactionRepository().createRoomTransaction(
        currentRoomTransaction.toJson()
    );
  }
  Future<void> updateRoomData()async{
    selectedRoomData.value.currentTransactionId = transactionId;
    selectedRoomData.value.roomStatus!.description = LocalKeys.kOccupied;
    selectedRoomData.value.roomStatus!.code =  LocalKeys.kStatusCode200.toString();
    await RoomDataRepository().updateRoom(selectedRoomData.value.toJson()).then((value) async {
      //showSnackBar("Updated RoomsData", Get.context!);
      await RoomStatusRepository().updateRoomStatus(selectedRoomData.value.roomStatus!.toJson());
    });
  }
  Future<void> updateAdminUserRoomsSold()async{
    await AdminUserRepository().updateAdminUser(AdminUser.incrementRoomsSold(currentAdmin!.toJson()).toJson());
  }

  Future<void> createClientActivity()async {
    await UserActivityRepository().createUserActivity(
        UserActivity(
            activityId: const Uuid().v1(),
            guestId: clientUserId,
            roomTransactionId: transactionId,
            employeeId: currentAdmin!.appId,
            employeeFullName: currentAdmin!.fullName,
            activityValue: roomCost.value,
            activityStatus: LocalKeys.kCheckIn.capitalize,
            description: LocalKeys.kCheckIn.capitalize,
            unit: LocalKeys.kRoom.capitalize,
            dateTime: checkInDate.value.toIso8601String()
        ).toJson()
    );
  }

}

