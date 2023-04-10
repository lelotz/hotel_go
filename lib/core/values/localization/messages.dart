
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
        "en": en,
        "sw": sw,
      };
}

class AppMessages{
  static const String numericOnly = "Value must be numeric";
  static const String alphabeticOnly = "Value must be alphabetic";
  static const String nonNegative = "Value must be positive";
  static const String isNotEmpty = "Value cannot be empty";
  static const String valueNotGreater = "Value cannot be greater than ";
  static const String cannotCollectZero = "Cannot collect 0 Tsh";
}

