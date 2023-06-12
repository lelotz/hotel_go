
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'langs/sw.dart';
import 'langs/en.dart';

class Messages extends Translations {
  static const fallbackLocale =  Locale('sw');
  static const supportedLocales =  [
    Locale('sw','tz'),
    Locale('en'),

  ];

  @override
  Map<String, Map<String, String>> get keys => {
        "sw": sw,
        "en": en,

      };
}

class AppMessages{
  static const String numericOnly = "Value must be numeric";
  static const String sessionRestorationMessage = "The system has restored your session. "
                                                  "If this is not your account you should LOG-OUT";
  static const String welcomeBack = "Welcome back, ";
  static const String alphabeticOnly = "Value must be alphabetic";
  static const String nonNegative = "Value must be positive";
  static const String isNotEmpty = "Value cannot be empty";
  static const String valueNotGreater = "Value cannot be greater than ";
  static const String cannotCollectZero = "Cannot collect 0 Tsh";
  static const String confirmSession = "You have a shift that was not logged out.\nSelect below to continue with current shift or start a new shift";

}

