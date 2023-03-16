
import 'dart:ui';

import 'package:get/get.dart';

import 'messages.dart';
class LocalizationController extends GetxController{
  Rx<Locale> currentLocal = Rx<Locale>(Messages.supportedLocales[0]);

  changeLocaleToEnglish(){
    Get.updateLocale(Messages.supportedLocales[1]);
    currentLocal.value = Messages.supportedLocales[1];
  }
  changeLocaleToSwahili(){
    Get.updateLocale(Messages.supportedLocales[0]);
    currentLocal.value = Messages.supportedLocales[0];
  }

  refreshData(){
    Get.updateLocale(currentLocal.value);
  }

}