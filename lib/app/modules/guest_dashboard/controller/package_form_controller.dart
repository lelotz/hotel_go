import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/guest_package_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/models_n/guest_package_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/values/localization/local_keys.dart';
import 'guest_dashboard_controller.dart';

class PackageFormController extends GetxController {
  GuestDashboardController guestDashboardController =
      Get.find<GuestDashboardController>();

  Rx<Map<String, dynamic>> get metaData =>  Get.find<GuestDashboardController>().metaData;

  TextEditingController packageDescriptionCtrl = TextEditingController();
  TextEditingController packageQuantityCtrl = TextEditingController();
  TextEditingController packageValueCtrl = TextEditingController();

  Rx<List<GuestPackage>> receivedPackagesView = Rx<List<GuestPackage>>([]);
  Rx<List<GuestPackage>> receivedPackagesBuffer = Rx<List<GuestPackage>>([]);
  Rx<List<GuestPackage>> returnedPackagesBuffer = Rx<List<GuestPackage>>([]);
  Rx<List<GuestPackage>> storedPackagesView = Rx<List<GuestPackage>>([]);

  Rx<bool> returningPackage = Rx<bool>(false);
  Rx<bool> receivingPackage = Rx<bool>(true);

  Rx<int> receivedPackagesViewCount = Rx<int>(0);
  Rx<int> receivedPackagesBufferCount = Rx<int>(0);
  Rx<int> returnedPackagesBufferCount = Rx<int>(0);

  @override
  void onInit() async {
    await getStoredPackages().then((value) async {
     // await getReturnedPackages().then((value) {});
    });
    super.onInit();
  }

  void updateUI() {
    receivedPackagesViewCount.value = receivedPackagesView.value.length;
    receivedPackagesBufferCount.value = receivedPackagesBuffer.value.length;
    returnedPackagesBufferCount.value = returnedPackagesBuffer.value.length;
    returnedPackagesBufferCount.value = returnedPackagesBuffer.value.length;
    guestDashboardController.updateUI();


  }

  clearPackageFormInputs() {
    packageValueCtrl.clear();
    packageQuantityCtrl.clear();
    packageDescriptionCtrl.clear();
  }

  Future<void> getStoredPackages({bool refresh = false}) async {
    receivedPackagesView.value.clear();
    storedPackagesView.value.clear();
    await GuestPackageRepository()
        .getStoredGuestPackageByRoomTransactionId(
            metaData.value[LocalKeys.kRoomTransaction].value.id!).then((value) {
              for(GuestPackage package in value){
                if(package.dateReturned == null){
                  storedPackagesView.value.add(package);
                }
              }
    });
    receivedPackagesView.value = storedPackagesView.value;
    updateUI();
  }

  Rx<Color> getSelectedPackageToReturn(GuestPackage packageSelected) {
    if (receivedPackagesBuffer.value.contains(packageSelected)) {
      return ColorsManager.success.obs;
    }
    return ColorsManager.white.obs;
  }



  void bufferNewStoredPackage() {
    GuestPackage package = GuestPackage(
      id: const Uuid().v1(),
      roomTransactionId: metaData.value[LocalKeys.kRoomTransaction].value.id!,
      storedEmployeeId: metaData.value[LocalKeys.kLoggedInUser].value.appId,
      dateStored: DateTime.now().toIso8601String(),
      description: packageDescriptionCtrl.text,
      unit: packageDescriptionCtrl.text,
      quantity: stringToInt(packageQuantityCtrl.text),
      value: stringToInt(packageValueCtrl.text),
      guestId: metaData.value[LocalKeys.kClientUser].value.clientId!,
    );

    receivedPackagesBuffer.value.add(package);
    updateUI();
    // showSnackBar("Package Loaded In Memory", Get.context!);
  }

  Future<void> storeClientPackage() async {
    for (GuestPackage element in receivedPackagesBuffer.value) {
      await GuestPackageRepository().storeGuestPackage(element);
      await SessionManagementRepository().createNewSessionActivity(
          SessionActivity(
                  id: Uuid().v1().toString(),
                  sessionId: Get.find<SessionManager>().currentSession.value.id,
                  transactionId: element.id,
                  transactionType: LocalKeys.kStorePackage,
                  dateTime: DateTime.now().toIso8601String())
              .toJson());
    }
    clearPackageFormInputs();
    receivedPackagesBuffer.value.clear();
    updateUI();
    await guestDashboardController.getUserActivity();
    guestDashboardController.update();
    Navigator.of(Get.overlayContext!).pop();
  }

  void bufferReturnedPackage(GuestPackage package) {

    if(returnedPackagesBuffer.value.contains(package)){
      returnedPackagesBuffer.value.remove(package);
    }else{
      package.returnedEmployeeId = metaData.value[LocalKeys.kLoggedInUser].value.appId;
      package.dateReturned = DateTime.now().toIso8601String();

      returnedPackagesBuffer.value.add(package);
    };
    updateUI();
    update();
  }

  Future<void> returnClientPackage() async {
    for (GuestPackage package in returnedPackagesBuffer.value) {
      await GuestPackageRepository().returnGuestPackage(package);
      await SessionManagementRepository().createNewSessionActivity(
          SessionActivity(
                  id: Uuid().v1().toString(),
                  sessionId: Get.find<SessionManager>().currentSession.value.id,
                  transactionId: package.id,
                  transactionType: LocalKeys.kReturnPackage,
                  dateTime: DateTime.now().toIso8601String())
              .toJson());
    }
    updateUI();
    await guestDashboardController.getUserActivity();
    guestDashboardController.update();
    Navigator.of(Get.overlayContext!).pop();
    returnedPackagesBuffer.value.clear();
  }

  receivePackage() {
    receivingPackage.value = true;
    returningPackage.value = false;
  }

  returnPackage() async {
    await getStoredPackages(refresh: true);
    receivingPackage.value = false;
    returningPackage.value = true;
  }
}
