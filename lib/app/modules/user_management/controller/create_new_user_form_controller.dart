import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/models_n/encrypted_data_model.dart';


class CreateUserController extends GetxController{

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  Rx<String> newUserPosition = Rx<String>('');
  Rx<String> newUserId = Rx<String>(const Uuid().v1());
  //UserManagementController userManagementController = Get.find<UserManagementController>();
  Rx<bool> userSuccessfullyCreated = false.obs;
  Rx<bool> initiatedUserCreation = false.obs;
  List<String> userPositions = [
    AppConstants.userRoles[1]!,
    AppConstants.userRoles[200]!,
    AppConstants.userRoles[300]!,
    AppConstants.userRoles[400]!,
    AppConstants.userRoles[500]!,
    AppConstants.userRoles[600]!,
  ];

  Future<void> createNewEmployee({bool isNewAdmin=false})async{
    initiatedUserCreation.value = true;
    await AdminUserRepository().createAdminUser(AdminUser(
      appId: userIdController.text,
      fullName: fullNameController.text,
      phone: phoneController.text,
      position: newUserPosition.value,
      status: 'ENABLED',
      roomsSold: 0,
    ).toJson()).then((value) async{
      if(value != null && value > 0) {
        await encryptNewUserPassword();
        userSuccessfullyCreated.value = true;
        Navigator.of(Get.overlayContext!).pop();
      }

    });
    initiatedUserCreation.value = false;

  }

  setUserPosition(String position){
    newUserPosition.value = position;

  }

  encryptNewUserPassword()async{
    await EncryptedDataRepository().createEncryptedData(EncryptedData(userId: userIdController.text,data: passWordController.text).toJson());
  }

}