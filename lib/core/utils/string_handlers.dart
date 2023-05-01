
import 'package:flutter/foundation.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:logger/logger.dart';


int stringToInt(String? givenString){
  Logger logger = AppLogger.instance.logger;
  int result = 0;
  try{
    result = int.parse(givenString!);
    if(result < 0) return 0;
  }catch(e){
    logger.e({'str->int ERROR': '','str': givenString},e);


  }

  return result;
}

double strToDouble(String? givenString){
  double result = 0.0;
  try{
    result = double.parse(givenString ?? '0');
  }catch(e){
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return result;
}