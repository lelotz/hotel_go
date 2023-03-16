
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'langs/sw.dart';
import 'langs/en.dart';

class Messages extends Translations {
  static const fallbackLocale =  Locale('en');
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

