
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';

import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/innit_data.dart';
import '../../../data/models_n/admin_user_model.dart';

void authControllerUnitTest(){


  test('''Auth Controller on Init test''',(){
    AuthController authController = AuthController();
    authController.onInit();


    final int mockIndex = authController.randomUserIndex;
    //expect(authController.adminUser.value.toJson(), AdminUser().toJson());

    expect(authController.fullNameCtrl.text, initAdminUsers[mockIndex].fullName!);
    expect(authController.adminUserPasswordCtrl.text, initAdminUsers[mockIndex].appId!);
    expect(authController.adminUser.value, initAdminUsers[mockIndex]);
    expect(authController.isLoading.value, false);
    expect(authController.isLoggedOut.value, false);
    expect(authController.hasInitiatedLogout.value, false);
    expect(authController.displayLogOutError.value, false);


    authController.dispose();

  });

  // group(description, () { })

  test('''Test User Authentication ''',()async{
    AuthController authController = AuthController();
      authController.onInit();
      //authController.sessionController.sessionExists.value = null;

    await authController.authenticateAdminUser();
    expect(authController.authResult.value ,LocalKeys.kSuccess);
    if(authController.sessionController.sessionExists.value == false) {
      expect(authController.sessionController.currentSession.value.toJson(), authController.sessionTracker.value.toJson());
    }


    authController.dispose();

  });
}