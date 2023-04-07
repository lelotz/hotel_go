import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/hotel_issues_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';

import 'package:hotel_pms/app/data/models_n/hotel_issues_model.dart';

import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/useful_math.dart';
import '../../../core/values/app_constants.dart';
import '../../data/models_n/session_activity_model.dart';
import '../guest_dashboard/controller/room_info_controller.dart';


class HotelIssuesFormController extends GetxController{
  AuthController authController = Get.find<AuthController>();
  RoomInfoController roomInfoController = Get.put(RoomInfoController());
  TextEditingController issueDescription = TextEditingController();
  TextEditingController stepsTakenDescription = TextEditingController();
  //Rx<HotelIssues> hotelIssues = Rx<HotelIssues>(HotelIssues());


  Rx<List<String>> allRooms = Rx<List<String>>([]);
  Rx<String> roomNumber = "".obs;
  Rx<String> issueStatus = "".obs;
  Rx<String> issueType = "".obs;

  List<String> hotelIssueTypes = HotelIssueType.getHotelIssueTypes();
  List<String> hotelIssueStatusType = HotelIssueType.getHotelIssueTypes();
  Rx<bool> creatingIssue = false.obs;

  @override
  onInit()async{
    super.onInit();
    await roomInfoController.onInit();
    allRooms.value = roomInfoController.allRooms.value;
    roomNumber.value = allRooms.value[random(0,allRooms.value.length)];
    issueDescription.text = "Testing Issues";
    stepsTakenDescription.text = ('${"Test"*5}\n')*10;
    issueStatus.value = hotelIssueStatusType[random(0, hotelIssueStatusType.length)];
    issueStatus.value = hotelIssueTypes[random(0, hotelIssueTypes.length)];
  }


  Future<void> createHotelIssue()async{
    creatingIssue.value = true;
    String id = const Uuid().v1();
    await HotelIssuesRepository().createHotelIssue(
      HotelIssues(
        id: id,
        employeeId: authController.adminUser.value.appId,
        roomNumber: roomNumber.value.isNotEmpty ? int.parse(roomNumber.value) : 0,
        issueDescription: issueDescription.text,
        stepsTaken: stepsTakenDescription.text,
        issueStatus: issueStatus.value,
        issueType: issueType.value,
        dateTime: DateTime.now().toIso8601String()
      ).toJson()
    ).then((value) async{
        await SessionManagementRepository().createNewSessionActivity(
            SessionActivity(
              id: const Uuid().v1(),
              sessionId: authController.sessionController.currentSession.value.id,
              transactionId: id,
              transactionType: TransactionTypes.hotelIssue,
              dateTime: DateTime.now().toIso8601String()
        ).toJson());
      });

    creatingIssue.value = false;
    Navigator.of(Get.overlayContext!).pop();
  }
  void setRoomNumber(String selectedRoomNumber){
    roomNumber.value = selectedRoomNumber;
  }

  void setHotelIssueType(String selectedIssueType){
    issueType.value = selectedIssueType;

  }
  void setHotelIssueStatus(String selectedStatus){
    issueStatus.value = selectedStatus;
  }


}