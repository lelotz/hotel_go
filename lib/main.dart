import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hotel_pms/app/modules/login_screen/bindings/auth_bindings.dart';
import 'package:hotel_pms/core/resourses/theme_manager.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'core/services/dynamic_theme.dart';
import 'core/values/localization/messages.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  loadMockNamesAndCountries();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return GetMaterialApp(
      title: 'Hotel PMS',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      defaultTransition: Transition.fadeIn,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [BotToastNavigatorObserver()],
      translations: Messages(),
      locale: Get.locale,
      initialBinding: AuthBinding(),
      builder: (context, child) {
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: botToastBuilder(context, child),

        );
        ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget),
          breakpoints: const [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        );
        return child;
      },
    );
  }
}



