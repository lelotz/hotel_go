// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_pms/app/modules/login_screen/tests/auth_controller_unit_tests.dart';
import 'package:hotel_pms/app/modules/login_screen/tests/session_manager_unit_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  sqfliteFfiInit();

  TestWidgetsFlutterBinding.ensureInitialized();


  //await SqlDatabase.instance.initiateDatabase();
  //WidgetsFlutterBinding.ensureInitialized();


  // await loadMockNamesAndCountries();

  await sessionManagerUnitTest();
  await authControllerUnitTest();
  // await checkInControllerUnitTests();

}
