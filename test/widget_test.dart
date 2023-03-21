// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/modules/login_screen/tests/auth_controller_unit_tests.dart';
import 'package:hotel_pms/app/modules/login_screen/tests/session_manager_unit_test.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';

import 'package:hotel_pms/main.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
class TestObject{
  String? hello;
  TestObject({required this.hello});

  set setHello (String str){str=hello!;}
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  sessionManagerUnitTest();
  authControllerUnitTest();

}
