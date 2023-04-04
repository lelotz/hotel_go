
import 'package:flutter/foundation.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';


int stringToInt(String? givenString){
  int result = 0;
  try{
    result = int.parse(givenString!);
  }catch(e){
    if (kDebugMode) {
      print(e.toString());
    }
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