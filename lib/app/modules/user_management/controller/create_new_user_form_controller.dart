import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_management_controller.dart';
import 'package:uuid/uuid.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/models_n/encrypted_data_model.dart';


class CreateUserController extends GetxController{

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  Rx<String> newUserPosition = Rx<String>('');
  Rx<String> newUserId = Rx<String>(const Uuid().v1());
  //UserManagementController userManagementController = Get.find<UserManagementController>();
  Rx<bool> userSuccessfullyCreated = false.obs;
  Rx<bool> initiatedUserCreation = false.obs;
  List<String> userPositions = ["Receptionist","Admin","Housekeeping","Accounting","Manager"];

  Future<void> createNewEmployee({bool isNewAdmin=false})async{
    initiatedUserCreation.value = true;
    await AdminUserRepository().createAdminUser(AdminUser(
      appId: newUserId.value,
      fullName: fullNameController.text,
      phone: phoneController.text,
      position: newUserPosition.value,
      roomsSold: 0,
    ).toJson()).then((value) async{
      if(value != null && value > 0) {
        await encryptNewUserPassword();
        userSuccessfullyCreated.value = true;
        //if(isNewAdmin) userManagementController.getAllAdminUsers();
        Navigator.of(Get.overlayContext!).pop();
      }

    });
  }

  setUserPosition(String position){
    newUserPosition.value = position;

  }

  encryptNewUserPassword()async{
    await EncryptedDataRepository().createEncryptedData(EncryptedData(userId: newUserId.value,data: passWordController.text).toJson());
  }

}