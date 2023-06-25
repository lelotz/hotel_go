
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';

import '../app/data/migration/session_id_in_room_transaction.dart';
import '../core/values/localization/config_keys.dart';

class Configs extends GetxController{
  String configsPath = kDebugMode ?
                      Directory.current.path + '\\assets\\configs\\configs.json'
                      : Directory.current.path + "\\data\\flutter_assets\\assets\\configs\\configs.json";

  Rx<Map<String,dynamic>> configs = Rx<Map<String,dynamic>>({});



  @override
  Future<void> onReady() async{
    configs.value.clear();
    configs.value = await readJsonFile(configsPath);
    print(configs.value.toString());
    await migrateDb();
    super.onReady();
  }

  dynamic writeJsonFile(dynamic data,String path,{FileMode fileMode = FileMode.write}) async {

    File file = await getFile(path);
    try{
      await file.writeAsString(json.encode(data),mode: fileMode);
    }catch(e){
    }
    return data;
  }

  File getFile(String path){
    late File file;
    try{
      file = File(path);
    }catch (e){

    }
    return file;
  }

  Future<void> migrateDb()async{
    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectRoomTransactions] == true){
      //currentStep.value = 'Injecting Room Transactions SessionIds';
      // isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInRoomTransactions();
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectRoomTransactions] = false;
      //isInjectingSessionIdToRoomTransactions.value = false;
      writeJsonFile(configs.value, configsPath);

    }

    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectOtherTransactions] == true){
      //currentStep.value = 'Injecting Other Transactions SessionIds';
      //isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectSessionIdInOtherTransactions();
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectOtherTransactions] = false;
      //isInjectingSessionIdToRoomTransactions.value = false;
      writeJsonFile(configs.value, configsPath);

    }

    if(configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectPaymentTransactions]){
      //currentStep.value = 'Injecting Collected Payments SessionIds';
      //isInjectingSessionIdToRoomTransactions.value = true;
      await SessionIdInjector.injectCollectedPayments();
      //isInjectingSessionIdToRoomTransactions.value = false;
      configs.value[ConfigKeys.cMigration][ConfigKeys.cInjectPaymentTransactions] = false;
      writeJsonFile(configs.value, configsPath);
    }

  }

  Future<Map<String, dynamic>> readJsonFile(String filePath) async {
    String? fileContent;
    // Creating a file
    File file = File(filePath);

    //check if file exists
    if (await file.exists()) {
      try {
        // reading the file and saving it as a String
        fileContent = await file.readAsString();

      } catch (e) {

      }
    }
    // decoding Json string fileContent into a map
    // It will be converted to a User model
    return json.decode(fileContent ?? "{'key':'value'}");
  }




}