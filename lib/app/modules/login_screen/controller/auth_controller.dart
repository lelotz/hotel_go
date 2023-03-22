import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/innit_data.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/utils/useful_math.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/local_storage/repository/session_management_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../routes/app_pages.dart';
import '../../homepage_screen/views/homepage_view.dart';


class AuthController extends GetxController{
  SessionManager sessionController = Get.put(SessionManager(isTest: true),permanent: true);
  TextEditingController adminUserPasswordCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  Rx<AdminUser> adminUser = Rx<AdminUser>(AdminUser());
  Rx<String> authResult = Rx<String>('Unknown Error');
  Rx<String> logOutResult = Rx<String>('SUCCESS');
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<List<String>> authorizedRoutes = Rx<List<String>>([]);
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

  @override
  void onInit() {
    super.onInit();
    //randomUserIndex = random(0, initAdminUsers.length);
    // TODO: implement onInit
    fullNameCtrl.text = initAdminUsers[randomUserIndex].fullName!;
    adminUserPasswordCtrl.text = initAdminUsers[randomUserIndex].appId!;
    adminUser.value = initAdminUsers[randomUserIndex];
    // adminUser.value.fullName = fullNameCtrl.text;
    // adminUser.value.appId = "00001WH";
    // adminUser.value.status = "ENABLED";
  }


  @override
  dispose(){
    super.dispose();
    adminUserPasswordCtrl.dispose();
    fullNameCtrl.dispose();
  }

  getAuthorizedRoutes(){
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
  Future<bool> authenticateAdminUser()async{
    bool isAuthenticated = false;
    isLoading.value = true;

    await AdminUserRepository().getAdminUserByName(fullNameCtrl.text).then((value) {
      if (value != null) {
        adminUser.value = AdminUser.fromJson(value[0]);
        adminUser.refresh();
      }
    }).then((value) async{
        await EncryptedDataRepository().getEncryptedDataByUserId(adminUser.value.appId!).then((value) async{
          if(value != null && value.length == 1){
            //logger.i({'password': value[0]});
            authResult.value = LocalKeys.kSuccess;
            isAuthenticated = true;

            sessionTracker.value = SessionTracker(
              id: const Uuid().v1(),
              employeeId: value[0]['userId'],
              dateCreated: DateTime.now().toIso8601String(),
            );

            await sessionController.createNewSession(sessionTracker.toJson());

            if(sessionController.sessionExists.value) sessionTracker.value = sessionController.currentSession.value;
            //showSnackBar(authResult.value, Get.context!);
            //logger.v("SUCCESS : Log in");
            if(isTest == false) Get.to(()=>HomePageView());
          }else if(value != null && value.isEmpty){
            authResult.value = LocalKeys.kInvalidCredentials;
            //showSnackBar('${authResult.value} ${adminUser.value.appId}', Get.context!);
          }else{
            //showSnackBar(authResult.value, Get.context!);
          }
          isLoading.value = false;
        });
      });
    await createLoginAttemptActivity(adminUser.value, isAuthenticated);

      return isAuthenticated;
    }


  Future<void> logOutUser()async{
    hasInitiatedLogout.value = true;
    int? activityStatus = -1;
    int? clearSessionStatus = -1;

    /// Set the log-off date
    await sessionController.updateSessionTracker();

    activityStatus = await createLogOutUserActivity();

    /// Delete current session
    clearSessionStatus = await clearUserSession();

    adminUser.value = AdminUser();
    isLoggedOut.value = true;
    hasInitiatedLogout.value = false;

    if(adminUser.value != AdminUser()) {
      logOutResult.value = "Error logging out";
      displayLogOutError.value = true;
      isLoggedOut.value = true;
    }
    if(isTest == false) Get.to(() => const LandingPage());

  }

  createLoginAttemptActivity(AdminUser adminUser,bool wasSuccess)async{
    UserActivityRepository().createUserActivity(UserActivity(
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


  Future<int> clearUserSession()async{
    //sessionController.dispose();
   return await SessionManagementRepository().deleteCurrentSession();
  }

  Future<int> createLogOutUserActivity()async{
    return await UserActivityRepository().createUserActivity(UserActivity(
      activityId: const Uuid().v1(),
      employeeId: adminUser.value.appId,
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