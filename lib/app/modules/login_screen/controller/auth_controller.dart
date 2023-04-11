import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/innit_data.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/utils/useful_math.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../routes/app_pages.dart';
import '../../homepage_screen/views/homepage_view.dart';


class AuthController extends GetxController{
  SessionManager sessionController = Get.put(SessionManager(isTest: false),permanent: true);
  TextEditingController adminUserPasswordCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  Rx<AdminUser> adminUser = Rx<AdminUser>(AdminUser());


  Rx<String> authResult = Rx<String>('');
  Rx<String> logOutResult = Rx<String>('SUCCESS');
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<List<String>> authorizedRoutes = Rx<List<String>>([]);
  Rx<bool> isAuthenticated = false.obs;

  Rx<bool> isLoggedOut = false.obs;
  Rx<bool> hasInitiatedLogout = false.obs;
  Rx<bool> displayLogOutError = false.obs;
  int randomUserIndex = random(0, initAdminUsers.length);
  Rx<SessionTracker> sessionTracker = Rx<SessionTracker>(SessionTracker());
  bool? isTest = false;
  Logger logger = AppLogger.instance.logger;


  List<String> routes = [

  ];
  AuthController({this.isTest});

  // @override
  // onInit(){
  //   super.onInit();
  //   fullNameCtrl.text = 'Dereck Olomi';
  //   adminUserPasswordCtrl.text = '00001WH';
  // }


  @override
  dispose(){
    super.dispose();
    adminUserPasswordCtrl.dispose();
    fullNameCtrl.dispose();
  }

  getAuthorizedRoutes()async{
    if(adminUser.value.position == AppConstants.userRoles[300]){
      authorizedRoutes.value.addAll([Routes.HOME,Routes.SALES_SCREEN]);
    }else{
      authorizedRoutes.value.addAll([
        Routes.HOME,Routes.SALES_SCREEN,
      ]);
    }
  }
  /// Authentication has 3 main steps
  ///
  /// 1. Fetch [AdminUser] by Name TODO: Change to by appId
  /// 2. User [AdminUser.appId] to match appId to encrypted password
  /// 3. Create new session [SessionTracker] if the last session is not logged out
  ///
  /// Recommendations from Testing
  /// 1. Create [UserActivity] for login attempt
  /// 2. Ensure [CurrentSessionTable] is empty before creating a new session.


  Future<bool> validateLoginAttempt()async{

    await AdminUserRepository().getAdminUserById(adminUserPasswordCtrl.text).then((value) {
      if (value != null && value.isNotEmpty) {
        adminUser.value = AdminUser.fromJson(value[0]);
        // adminUser.refresh();
      }
    });
    if(adminUser.value.appId == null){
      authResult.value = 'Umekosea jina au password';
      return false;
    }

    return true;
  }

  Future<bool> loginUser()async{

    isLoading.value = true;

    await authenticateUser();

    if(isAuthenticated.value) {
      await sessionController.createNewSession(adminUser.value.appId!);
      sessionTracker.value = sessionController.currentSession.value;

    }else{
      logger.w({'failed to auth user': adminUser.value.toJson()});
    }

    await createLoginAttemptActivity(adminUser.value, isAuthenticated.value);

    isLoading.value = false;

    if(isTest == false && isAuthenticated.value) Get.to(()=>HomePageView());

    clearInputs();
    authResult.value = '';

    return isAuthenticated.value;
  }

  clearInputs(){
    adminUserPasswordCtrl.clear();
    fullNameCtrl.clear();
  }

  Future<void> authenticateUser()async{
    await EncryptedDataRepository().getEncryptedDataByUserId(adminUser.value.appId!).then((value) async{
      if(value != null && value.length == 1 && value.first['userId'] == adminUser.value.appId){
        isAuthenticated.value = true;
        authResult.value = LocalKeys.kSuccess;
      }else if(value != null && value.isEmpty){
        authResult.value = LocalKeys.kInvalidCredentials;
        // logger.e({'failed to match encrypted data':'','toMatch':adminUser.value.appId,'given':value.first['userId']});
      }
    });
  }



  Future<void> logOutUser()async{
    hasInitiatedLogout.value = true;
    int? activityStatus = -1;

    /// Set the log-off date
    await sessionController.updateSessionTracker();

    activityStatus = await createLogOutUserActivity();

    adminUser.value = AdminUser();
    isLoggedOut.value = true;
    hasInitiatedLogout.value = false;

    if(adminUser.value.appId != AdminUser().appId) {
      logOutResult.value = "Error logging out";
      displayLogOutError.value = true;
      isLoggedOut.value = true;
    }
    if(isTest == false) Get.to(() => LandingPage());

  }

  Future<void> updateAdminUser()async{
    if(sessionController.initialized && sessionController.currentSession.value.employeeId != null){
      await AdminUserRepository().getAdminUserById(sessionController.currentSession.value.employeeId!).then((value) {
        if (value != null && value.isNotEmpty) {
          adminUser(AdminUser.fromJson(value[0]));
          adminUser.value = AdminUser.fromJson(value[0]);
          adminUser.refresh();
        }
      });
    }
  }

  Future<int> createLoginAttemptActivity(AdminUser adminUser,bool wasSuccess)async{
    return await UserActivityRepository().createUserActivity(UserActivity(
      activityId: const Uuid().v1(),
      activityStatus: wasSuccess ? 'SUCCESSFUL' : 'ERROR',
      activityValue: 0,
      employeeId: adminUser.appId,
      employeeFullName:adminUser.fullName ,
      description: 'logInAttempt',
      dateTime: DateTime.now().toIso8601String(),
      guestId: '',
      unit: ''
    ).toJson());
  }




  Future<int> createLogOutUserActivity()async{
    return await UserActivityRepository().createUserActivity(UserActivity(
      activityId: const Uuid().v1(),
      employeeId:adminUser.value.appId,
      employeeFullName: adminUser.value.fullName,
      guestId: '-',
      activityValue: 0,
      unit: 'logOutUser',
      activityStatus: 'LOG-OUT',
      description: 'LOG-OUT',
      dateTime: DateTime.now().toIso8601String(),
    ).toJson());
  }
}