
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/innit_data.dart';
import '../../../data/models_n/admin_user_model.dart';

 authControllerUnitTest()async{


  test('''Auth Controller on Init test''',()async{
    AuthController authController = AuthController();
    authController.onInit();


    final int mockIndex = authController.randomUserIndex;
    //expect(authController.adminUser.value.toJson(), AdminUser().toJson());

    expect(authController.fullNameCtrl.text, initAdminUsers[mockIndex].fullName!);
   // expect(authController.adminUserPasswordCtrl.text, initAdminUsers[mockIndex].!);
    expect(authController.adminUser.value, initAdminUsers[mockIndex]);
    expect(authController.isLoading.value, false);
    expect(authController.isLoggedOut.value, false);
    expect(authController.hasInitiatedLogout.value, false);
    expect(authController.displayLogOutError.value, false);


    authController.dispose();

  });

  // group(description, () { })
  for(int i=0; i== 0;i++){
    test('''Test User Log In && Log off''',()async{
      AuthController authController = Get.put(AuthController(isTest: true));
      authController.onInit();
      //authController.sessionController.sessionExists.value = null;

      await authController.loginUser();
      expect(authController.authResult.value ,LocalKeys.kSuccess);
      if(authController.sessionController.sessionExists.value == false) {
        expect(authController.sessionController.currentSession.value.toJson(), authController.sessionTracker.value.toJson());
      }

      await authController.logOutUser();

      expect(authController.sessionController.currentSession.value.dateEnded!.isNotEmpty, true);
      expect(authController.isLoggedOut.value, true);
      expect(authController.adminUser.value.toJson(), AdminUser().toJson());
      expect(authController.isLoggedOut.value ,true);
      expect( authController.hasInitiatedLogout.value , false);
      expect(authController.isLoggedOut.value, true);
      authController.randomUserIndex = random(0,2);
    });

  }



}