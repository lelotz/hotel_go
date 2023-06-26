import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hotel_pms/core/logs/local_logger.dart';
import 'package:logger/logger.dart';

import '../../configs/Configs.dart';

class AppLogger {
  AppLogger._privateConstruct();
  static final AppLogger instance = AppLogger._privateConstruct();
  LocalLogger localLogger = LocalLogger.instance;
  Map<String,dynamic> configs = {};

  AppLogger(){
    setConfigs();
  }

  setConfigs(){
    if(configs.isEmpty) {
      print('setting log configs');
      configs = Get
          .put(Configs())
          .configs
          .value;
    }
    return configs;
  }

  getConfigs(){
    if(configs.isEmpty) return setConfigs();
    return configs;
  }

  bool shouldPrint(){
    setConfigs();
    if(configs.containsKey('log')){
      Map<String,dynamic> logConfigs = configs['log'];

      if(logConfigs.containsKey('print')){
        return logConfigs['print'];
      }
    }

    return false;
  }

  Logger get logger => Logger(
      printer: shouldPrint() ? PrettyPrinter(methodCount: 0): LocalLogger.instance,
  );

}