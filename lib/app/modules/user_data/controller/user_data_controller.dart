import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';

import '../../../data/models_n/admin_user_model.dart';

class UserData extends GetxController{
  Rx<List<AdminUser>> users = Rx<List<AdminUser>>([]);
  Rx<Map<String,dynamic>> userData = Rx<Map<String,dynamic>>({});

  @override
  Future<void> onInit()async{
    super.onInit();
    await getUserData();

  }

  getUserData()async{
    users.value.clear();
    users.value = await AdminUserRepository().getAllAdminUsers();
    print(userData.value);
    setUserData();
  }

  setUserData()async{
    userData.value.clear();
    for(AdminUser user in users.value){
      userData.value.addAll({user.id!: user.fullName});
      userData.refresh();
    }
  }

}