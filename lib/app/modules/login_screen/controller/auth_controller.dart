import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/innit_data.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen_alpha.dart';
import 'package:hotel_pms/configs/Configs.dart';
import 'package:hotel_pms/core/logs/local_logger.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/utils/useful_math.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/values/localization/config_keys.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/local_storage/repository/session_management_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../data/migration/session_id_in_room_transaction.dart';
import '../../../routes/app_pages.dart';
import '../../homepage_screen/views/homepage_view.dart';
import '../validators/password_validator.dart';
import '../validators/user_name_validator.dart';
import '../views/confirm_current_session_popup.dart';

class AuthController extends GetxController {
  SessionManager sessionController =
      Get.put(SessionManager(isTest: false), permanent: true);
  Configs configsController = Get.put(Configs());
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
  LocalLogger localLogger = LocalLogger.instance;
  Rx<Map<String,dynamic>> configs = Rx<Map<String,dynamic>>({});

  List<String> routes = [];

  FileManager fileManager = FileManager();

  AuthController({this.isTest});

  @override
  onInit()async{
    super.onInit();
    await loadConfigs();
    if(await restoreUserSession()){
      Get.to(()=>HomePageView());
      buildDialog(
          Get.overlayContext!, "",
          ConfirmCurrentSession(),
          height: 300,width: 800
      );
    }

  }

  @override
  dispose() {
    super.dispose();
    adminUserPasswordCtrl.dispose();
    fullNameCtrl.dispose();
  }

  loadConfigs()async{
    await configsController.onReady();
    configs.value = configsController.configs.value;
  }

  getAuthorizedRoutes() async {
    if (adminUser.value.position == AppConstants.userRoles[300]) {
      authorizedRoutes.value.addAll([Routes.HOME, Routes.SALES_SCREEN]);
    } else {
      authorizedRoutes.value.addAll([
        Routes.HOME,
        Routes.SALES_SCREEN,
      ]);
    }
  }

  /// Authentication has 3 main steps
  ///
  /// 1. Fetch [AdminUser] by Name
  /// 2. User [AdminUser.id] to match encrypted password with the same [AdminUser.id]
  /// 3. Create new session [SessionTracker] if the last session is not logged out
  ///
  /// Recommendations from Testing
  /// 1. Create [UserActivity] for login attempt
  /// 2. Ensure [CurrentSessionTable] is empty before creating a new session.

  Future<bool> validateLoginAttempt() async {

    await AdminUserRepository()
        .getAdminUserByName(fullNameCtrl.text)
        .then((value)async{
      if (value?.id!=null) {
        adminUser.value = value!;
      }
    });
    if (adminUser.value.id == null) {
      authResult.value = 'Umekosea jina au password';
      return false;
    }

    return true;
  }

  String? trackValidation(String? input){
    return isAuthenticated.value ? null : 'Umekosea Jina au Password';
  }

  FormGroup getLoginForm (){
    return fb.group(<String,Object>{
      'username':FormControl<String>(
          validators: [Validators.required,],
          asyncValidators: [UserNameAsyncValidator(validateUserName)]
      ),
      'password':FormControl<String>(
          validators: [Validators.required],
        asyncValidators: [PasswordAsyncValidator(validatePassword)]
      )

    });
  }


  Future<bool?> validateUserName(String userName)async{
    bool userNameExists = false;
     await AdminUserRepository()
        .getAdminUserByName(userName)
        .then((value){
      if (value?.id!=null) {
        adminUser.value = value!;
        userNameExists = true;
      }
    });
     logger.i('user_object_at_name_validation ${adminUser.value.toJson()} userExists : ${userNameExists}');
     return userNameExists;
  }

  Future<bool> validatePassword(String password)async{
    bool passwordIsValid = false;
    await EncryptedDataRepository()
        .getEncryptedDataByUserId(adminUser.value.id??'')
        .then((value)  {
      if (value.length == 1 &&
          value.first.userId == adminUser.value.id && password == value.first.data) {
        passwordIsValid = true;
        isAuthenticated.value = true;
      } else if (value.isEmpty) {
        authResult.value = LocalKeys.kInvalidCredentials;
        passwordIsValid = false;
      }
    });
    return passwordIsValid;
  }



  Future<bool> restoreUserSession()async{
    SessionTracker? userSession = await SessionManagementRepository().getLatestOpenSession();
    if(userSession==null){
      return false;
    }
    adminUser.value = await AdminUserRepository().getAdminUserById(userSession.employeeId!);
    fullNameCtrl.text = adminUser.value.fullName!;

    await EncryptedDataRepository()
        .getEncryptedDataByUserId(adminUser.value.id??'')
        .then((value)  {
      if (
      value.length == 1 &&
          value.first.userId == adminUser.value.id) {
        isAuthenticated.value = true;
        authResult.value = LocalKeys.kSuccess;
      } else if (value.isEmpty) {
        authResult.value = LocalKeys.kInvalidCredentials;
        isAuthenticated.value = false;
        adminUserPasswordCtrl.clear();
        localLogger.exportLog(data: {
          'description': 'Could match restored sessionUserId with the UserId encrypted data',
          'session': userSession.toJson(),'user':adminUser.value.toJson()
        }, error: "Auto-Login-Error");

      }
    });

    await sessionController.setCurrentSession(fromExistingSession: userSession);;


    return isAuthenticated.value ? true : false;

  }

  void resetLoginAttempt(){
        clearInputs();

  }

  Future<bool> loginUser() async {
    isLoading.value = true;
    logger.i('user_object_at_login ${adminUser.value.toJson()}');

    if (isAuthenticated.value) {
      await createLoginAttemptActivity(adminUser.value, isAuthenticated.value);
      await sessionController.createSession(userId:adminUser.value.id!);
      sessionTracker.value = sessionController.currentSession.value;

      Get.to(()=>HomePageView());
    } else {
      logger.w({'failed to auth user': adminUser.value.toJson()});
    }

    isLoading.value = false;

    return isAuthenticated.value;
  }

  clearInputs() {
    adminUserPasswordCtrl.clear();
    fullNameCtrl.clear();
  }



  Future<void> authenticateUser() async {
    await EncryptedDataRepository()
        .getEncryptedDataByUserId(adminUser.value.id!)
        .then((value) async {
      if (
          value.length == 1 &&
          value.first.userId == adminUser.value.id && adminUserPasswordCtrl.text == value.first.data) {
        isAuthenticated.value = true;
        authResult.value = LocalKeys.kSuccess;
      } else if (value.isEmpty) {
        authResult.value = LocalKeys.kInvalidCredentials;
      }
    });

  }

  Future<void> logOutUser() async {
    hasInitiatedLogout.value = true;
    
    /// Set the log-off date
    await sessionController.updateSessionTracker();

    await createLogOutUserActivity();

    adminUser.value = AdminUser();
    isLoggedOut.value = true;
    hasInitiatedLogout.value = false;

    if (adminUser.value.id != AdminUser().id) {
      logOutResult.value = "Error logging out";
      displayLogOutError.value = true;
      isLoggedOut.value = true;
    }
    if (isTest == false) Get.to(() => LoginScreen());
  }

  Future<void> updateAdminUser() async {
    if (sessionController.initialized &&
        sessionController.currentSession.value.employeeId != null) {
      await AdminUserRepository()
          .getAdminUserById(sessionController.currentSession.value.employeeId!)
          .then((value) {
        if (value.id!=null) {
          //adminUser(AdminUser.fromJson(value[0]));
          adminUser.value = value;
          adminUser.refresh();
        }
      });
    }
  }

  Future<int> createLoginAttemptActivity(
      AdminUser adminUser, bool wasSuccess) async {
    return await UserActivityRepository().createUserActivity(UserActivity(
            activityId: const Uuid().v1(),
            activityStatus: wasSuccess ? 'SUCCESSFUL' : 'ERROR',
            activityValue: 0,
            employeeId: adminUser.id,
            employeeFullName: adminUser.fullName,
            description: 'logInAttempt',
            dateTime: DateTime.now().toIso8601String(),
            guestId: '',
            unit: '')
        .toJson());
  }

  Future<int> createLogOutUserActivity() async {
    return await UserActivityRepository().createUserActivity(UserActivity(
      activityId: const Uuid().v1(),
      employeeId: adminUser.value.id,
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
