import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import '../values/localization/messages.dart';

class DataValidation {

  static isAlphabeticOnly(String controller){
    controller = controller.removeAllWhitespace;

    if(isNotEmpty(controller)!=null) return isNotEmpty(controller);

    if(controller.isAlphabetOnly == false){
      return AppMessages.alphabeticOnly.tr;
    }
    return null;
  }

  static isNotEmpty(String controller){
    controller = controller.removeAllWhitespace;
    if(controller.isNotEmpty == false){
      return AppMessages.isNotEmpty.tr;
    }
    return null;
  }



  static isSpaceSeparatedAlphabeticOnly(String controller){
    controller = controller.removeAllWhitespace;
    if(controller.isAlphabetOnly == false){
      return AppMessages.alphabeticOnly.tr;
    }
    return null;
  }
  static isNumericAndNotGreaterThan(int comparator,String value){
    if(value.isNumericOnly){
      if(stringToInt(value) > comparator){
        return '${AppMessages.valueNotGreater}$comparator';
      }
    }else{
      return isNumeric(value);
    }

    return null;
  }

  static isNumeric(String controller){

    if(isNotEmpty(controller) != null) return isNotEmpty(controller);

    if(controller.isNumericOnly == false){
      return AppMessages.numericOnly.tr;
    }else if(stringToInt(controller) < 0){
      return AppMessages.nonNegative.tr;
    }
    return null;
  }
}