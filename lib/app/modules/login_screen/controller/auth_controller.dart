import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
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
import '../../../../core/values/localization/config_keys.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/encrypted_data_repo.dart';
import '../../../data/local_storage/repository/user_activity_repo.dart';
import '../../../data/migration/session_id_in_room_transaction.dart';
import '../../../routes/app_pages.dart';
import '../../homepage_screen/views/homepage_view.dart';

class AuthController extends GetxController {
  SessionManager sessionController =
      Get.put(SessionManager(isTest: false), permanent: true);
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
  Rx<Map<String,dynamic>> configs = Rx<Map<String,dynamic>>({});

  List<String> routes = [];
  String configFilePath = kDebugMode ?
  Directory.current.path + '\\assets\\configs\\configs.json'
      : Directory.current.path + "\\data\\flutter_assets\\assets\\configs\\configs.json";
  FileManager fileManager = FileManager();

  AuthController({this.isTest});

  @override
  onInit()async{
    super.onInit();
    await loadConfigs();

  }

  @override
  dispose() {
    super.dispose();
    adminUserPasswordCtrl.dispose();
    fullNameCtrl.dispose();
  }

  loadConfigs()async{
    configs.value = await fileManager.readJsonFile(configFilePath);
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
      if (value.isNotEmpty) {
        adminUser.value = value[0];

      }
    });
    if (adminUser.value.id == null) {
      authResult.value = 'Umekosea jina au password';
      return false;
    }

    return true;
  }

  Future<bool> loginUser() async {
    isLoading.value = true;

    await authenticateUser();

    if (isAuthenticated.value) {
      await sessionController.validateNewSession(adminUser.value.id!);
      sessionTracker.value = sessionController.currentSession.value;
      await migrateDb();
    } else {
      logger.w({'failed to auth user': adminUser.value.toJson()});
    }

    isLoading.value = false;
    clearInputs();
    authResult.value = '';

    return isAuthenticated.value;
  }

  clearInputs() {
    adminUserPasswordCtrl.clear();
    fullNameCtrl.clear();
  }

  Future<void> migrateDb()async{
    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectRoomTransactions] == true){
      //currentStep.value = 'Injecting Room Transactions SessionIds';
      // isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInRoomTransactions();
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectRoomTransactions] = false;
      //isInjectingSessionIdToRoomTransactions.value = false;
      fileManager.writeJsonFile(configs.value, configFilePath);

    }

    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectOtherTransactions] == true){
      //currentStep.value = 'Injecting Other Transactions SessionIds';
      //isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInOtherTransactions();
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectOtherTransactions] = false;
      //isInjectingSessionIdToRoomTransactions.value = false;
      fileManager.writeJsonFile(configs.value, configFilePath);

    }

    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectPaymentTransactions]){
      //currentStep.value = 'Injecting Collected Payments SessionIds';
      //isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectCollectedPayments();
      //isInjectingSessionIdToRoomTransactions.value = false;
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectPaymentTransactions] = false;
      fileManager.writeJsonFile(configs.value, configFilePath);
    }

  }

  Future<void> authenticateUser() async {
    await EncryptedDataRepository()
        .getEncryptedDataByUserId(adminUser.value.id!)
        .then((value) async {
      if (
          value.length == 1 &&
          value.first.userId == adminUser.value.id) {
        isAuthenticated.value = true;
        authResult.value = LocalKeys.kSuccess;
      } else if (value.isEmpty) {
        authResult.value = LocalKeys.kInvalidCredentials;
      }
    });

    await createLoginAttemptActivity(adminUser.value, isAuthenticated.value);
  }

  Future<void> logOutUser() async {
    hasInitiatedLogout.value = true;
    int? activityStatus = -1;

    /// Set the log-off date
    await sessionController.updateSessionTracker();

    activityStatus = await createLogOutUserActivity();

    adminUser.value = AdminUser();
    isLoggedOut.value = true;
    hasInitiatedLogout.value = false;

    if (adminUser.value.id != AdminUser().id) {
      logOutResult.value = "Error logging out";
      displayLogOutError.value = true;
      isLoggedOut.value = true;
    }
    if (isTest == false) Get.to(() => LandingPage());
  }

  Future<void> updateAdminUser() async {
    if (sessionController.initialized &&
        sessionController.currentSession.value.employeeId != null) {
      await AdminUserRepository()
          .getAdminUserById(sessionController.currentSession.value.employeeId!)
          .then((value) {
        if (value != null && value.isNotEmpty) {
          adminUser(AdminUser.fromJson(value[0]));
          adminUser.value = AdminUser.fromJson(value[0]);
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
