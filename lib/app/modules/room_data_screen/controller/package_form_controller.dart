import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/local_storage/table_keys.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/room_details_controller.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:hotel_pms/widgets/dialogs/activity_status_dialog.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';

class PackageFormController extends GetxController{
  Rx<Map<String,dynamic>> get metaData => Get.find<RoomDetailsController>().metaData;
  Rx<List<UserActivity>> get userActivity => Get.find<RoomDetailsController>().userActivity;

  TextEditingController packageDescriptionCtrl = TextEditingController();
  TextEditingController packageQuantityCtrl = TextEditingController();
  TextEditingController packageValueCtrl = TextEditingController();

  Rx<List<UserActivity>> receivedPackagesView = Rx<List<UserActivity>>([]);
  Rx<List<UserActivity>> receivedPackagesBuffer = Rx<List<UserActivity>>([]);
  Rx<List<UserActivity>> returnedPackagesBuffer = Rx<List<UserActivity>>([]);

  Rx<bool> returningPackage = Rx<bool>(false);
  Rx<bool> receivingPackage = Rx<bool>(true);

  Rx<int> receivedPackagesViewCount = Rx<int>(0);
  Rx<int> receivedPackagesBufferCount = Rx<int>(0);
  Rx<int> returnedPackagesBufferCount = Rx<int>(0);

  @override
  void onInit()async {
      await getStoredPackages().then((value) async{
        await getReturnedPackages().then((value) {
        });
      });
    super.onInit();
  }

  void updateUI(){
    receivedPackagesViewCount.value = receivedPackagesView.value.length;
    receivedPackagesBufferCount.value = receivedPackagesBuffer.value.length;
    returnedPackagesBufferCount.value = returnedPackagesBuffer.value.length;
    returnedPackagesBufferCount.value = returnedPackagesBuffer.value.length;
    Get.find<RoomDetailsController>().updateUI();
    userActivity.refresh();
  }

  clearPackageFormInputs(){
    packageValueCtrl.clear();
    packageQuantityCtrl.clear();
    packageDescriptionCtrl.clear();
  }

  Future<void> getStoredPackages()async{
    receivedPackagesView.value.clear();
    await UserActivityRepository().getUserActivity(
      tableName: ReceivedPackagesTable.tableName,
      metaData.value[LocalKeys.kClientUser].value.clientId!, metaData.value[LocalKeys.kRoomTransaction].value.id!,
    ).then((value)async {
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          userActivity.value.add(UserActivity.fromJson(element));
          if(await packageIsReturned(element[UserActivityTable.activityId]) == false){
            receivedPackagesView.value.add(UserActivity.fromJson(element));
          }
          //returnedPackages.value.add(UserActivity.fromJson(element));
        }
        showSnackBar("Fetched Returned Packages : ${userActivity.value.length}", Get.context!);
      }else{
        showSnackBar("FAILED: Fetch Returned Packages", Get.context!);
      }
    });
    updateUI();
  }

  Future<bool> packageIsReturned(String packageId)async{
    List<Map<String,dynamic>> receivedPackages = [];
    List<Map<String,dynamic>> returnedPackages = [];
    await UserActivityRepository().getUserActivityByActivityId(
        packageId,tableName: ReceivedPackagesTable.tableName).then((value) async{
      if(value != null && value.isNotEmpty)
      {
        receivedPackages = value;
        await UserActivityRepository().getUserActivityByActivityId(
            packageId, tableName: ReturnedPackagesTable.tableName ).then((value){
          if(value != null && value.isNotEmpty){
            returnedPackages = value;
          }
        });
      }else{
        return false;
      }});

    if(returnedPackages.isEmpty){
      return false;
    }else{
      return  true;
    }
  }

  Future<void> getReturnedPackages()async{
    await UserActivityRepository().getUserActivity(
      tableName: ReturnedPackagesTable.tableName,
      metaData.value[LocalKeys.kClientUser].value.clientId!,  metaData.value[LocalKeys.kRoomTransaction].value.id!,
    ).then((value) {
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          userActivity.value.add(UserActivity.fromJson(element));
          //returnedPackages.value.add(UserActivity.fromJson(element));
        }
        showSnackBar("Fetched Returned Packages : ${userActivity.value.length}", Get.context!);
      }else{
        showSnackBar("FAILED: Fetch Returned Packages", Get.context!);
      }
    });
    updateUI();
  }

  void bufferNewStoredPackage(){
    UserActivity package = UserActivity(
        activityId: const Uuid().v1(),
        roomTransactionId:  metaData.value[LocalKeys.kRoomTransaction].value.id!,
        guestId:  metaData.value[LocalKeys.kClientUser].value.clientId!,
        employeeId: metaData.value[LocalKeys.kLoggedInUser].appId,
        employeeFullName: metaData.value[LocalKeys.kLoggedInUser].fullName,
        activityStatus: LocalKeys.kStorePackage,
        description: packageDescriptionCtrl.text,
        unit: packageQuantityCtrl.text,
        activityValue: stringToInt(packageValueCtrl.text),
        dateTime: DateTime.now().toIso8601String()
    );

    receivedPackagesBuffer.value.add(package);
    updateUI();
    showSnackBar("Package Loaded In Memory", Get.context!);
  }

  Future<void> storeClientPackage()async{
    for(UserActivity element in receivedPackagesBuffer.value){
      await UserActivityRepository().createUserActivity(
          element.toJson(),tableName: ReceivedPackagesTable.tableName).then((value) {
        receivedPackagesView.value.add(element);
        userActivity.value.add(element);
      });

    }
    //getUserActivity();
    clearPackageFormInputs();
    receivedPackagesBuffer.value.clear();
    updateUI();
    Get.find<RoomDetailsController>().updateUI();
    //successAlert("Package Stored", LocalKeys.kSuccess.tr,context: Get.context!);
    Navigator.of(Get.overlayContext!).pop();
  }

  void bufferReturnedPackage(UserActivity package){

    receivedPackagesView.value.remove(package);
    package.activityStatus = LocalKeys.kReturnPackage;
    package.dateTime = DateTime.now().toIso8601String();
    returnedPackagesBuffer.value.add(package);
    updateUI();
    showSnackBar("Returned package loaded to memory", Get.context!);
  }

  Future<void> returnClientPackage()async{
    for(UserActivity package in returnedPackagesBuffer.value){
      await UserActivityRepository().createUserActivity(
        tableName: ReturnedPackagesTable.tableName,
        package.toJson(),
      ).then((value) {
        userActivity.value.add(package);
      });
    }
    updateUI();
    Navigator.of(Get.overlayContext!).pop();
    returnedPackagesBuffer.value.clear();

    showSnackBar("Package Return", Get.context!);
  }

  receivePackage(){
    receivingPackage.value = true;
    returningPackage.value = false;
  }

  returnPackage(){
    receivingPackage.value = false;
    returningPackage.value = true;
  }

}