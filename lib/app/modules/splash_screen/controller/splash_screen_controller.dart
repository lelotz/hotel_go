import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/migration/session_id_in_room_transaction.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/app/modules/user_data/controller/user_data_controller.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/values/localization/langs/sw.dart';
import 'package:logger/logger.dart';

class SplashScreenController extends GetxController{
  // kDebugMode ? Assets.kLogo : await fileManager.executableDirectory + Assets.kLogo
  String configFilePath = kDebugMode ?
    Directory.current.path + '\\assets\\configs\\configs.json'
      : Directory.current.path + "\\data\\flutter_assets\\assets\\configs\\configs.json";
  Rx<bool> isInitialized = false.obs;
  Rx<bool> isInjectingSessionIdToRoomTransactions = false.obs;

  Rx<bool> appDirectoryFound = false.obs;
  Rx<String> appDirectory = ''.obs;
  Rx<Map<String,dynamic>> configs = Rx<Map<String,dynamic>>({});
  FileManager fileManager = FileManager();
  UserData userData = Get.put(UserData(),permanent: true);
  Rx<String> appExecutablePath = Rx<String>('');
  Rx<String> currentStep = Rx<String>('');
  Logger logger = AppLogger.instance.logger;



  @override
  Future<void> onReady() async{
    currentStep.value = configFilePath;
    logger.i(configFilePath);
    // currentStep.value = 'Getting userData';
    // await loadLocalizationData();
    await loadConfigs();
    currentStep.value = 'Getting userData';
    await userData.onInit();
    currentStep.value = 'Validating App Directories';
    await validateAppDirectory();
    currentStep.value = 'Getting executable Directory';

    appExecutablePath.value = await fileManager.executableDirectory;

    await migrateDb();
    super.onReady();
  }

  loadConfigs()async{
    configs.value = await fileManager.readJsonFile(configFilePath);
  }

  loadLocalizationData()async{
    await fileManager.writeJsonFile(sw, 'lib/core/values/localization/langs/sw.json');
  }

  Future<void> migrateDb()async{
    if(configs.value['migration']['injectRoomSessionId'] == true){
      currentStep.value = 'Injecting SessionIds';
      isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInRoomTransactions();
      configs.value['migration']['injectRoomSessionId'] = false;
      isInjectingSessionIdToRoomTransactions.value = false;
      fileManager.writeJsonFile(configs.value, configFilePath);

    }

    if(configs.value['migration']['injectOtherSessionId'] == true){
      currentStep.value = 'Injecting SessionIds';
      isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInOtherTransactions();
      configs.value['migration']['injectOtherSessionId'] = false;
      isInjectingSessionIdToRoomTransactions.value = false;
      fileManager.writeJsonFile(configs.value, configFilePath);

    }

  }

  Future<void> validateAppDirectory()async{
    appDirectory.value = await fileManager.directoryPath.then((value) => value == null ? '' : value.path);
    isInitialized.value = true;
    if(appDirectory.value != '') appDirectoryFound.value = true;
    if(appDirectoryFound.value) {
      Get.to(() => LandingPage());
    }else{
      currentStep.value = 'Error getting appDirectory ${appDirectory.value}';
    }
  }

}