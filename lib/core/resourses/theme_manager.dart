import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_manager.dart';
import 'font_styles_manager.dart';
import 'size_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      //main colors of the app
      scaffoldBackgroundColor: const Color.fromARGB(255, 247, 245, 245),
      primaryColor: ColorsManager.primary,
      primaryColorLight: ColorsManager.primary.withOpacity(.7),
      disabledColor: ColorsManager.grey,
      platform: TargetPlatform.iOS,
      splashColor: ColorsManager.primary.withOpacity(.7),

      dataTableTheme: DataTableThemeData(
        headingRowColor:  MaterialStateColor.resolveWith((states)  => ColorsManager.white),
        dataRowColor: MaterialStateColor.resolveWith((states)  => ColorsManager.white),

      ),

      //card theme for the cards
      cardTheme: CardTheme(
        color: ColorsManager.white,
        shadowColor: ColorsManager.grey,
        elevation: AppSize.size4,
        margin: const EdgeInsets.all(AppMargin.margin8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: AppSize.size4,
        iconTheme: const IconThemeData(color: ColorsManager.primary),
        backgroundColor: ColorsManager.primary,
        shadowColor: ColorsManager.grey1,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: ColorsManager.primary, // Navigation bar
          statusBarColor: ColorsManager.primary, // Status bar
        ),
        titleTextStyle: getRegularTextStyle(
            color: ColorsManager.white, fontSize: AppSize.size18),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ColorsManager.primary,
        disabledColor: ColorsManager.grey1,
        splashColor: ColorsManager.primary.withOpacity(.7),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.radius20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          textStyle: getRegularTextStyle(
            color: ColorsManager.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: TextTheme(
          displayLarge: getMediumTextStyle(
              color: ColorsManager.darkGrey, fontSize: AppSize.size18),
          titleMedium: getMediumTextStyle(
              color: ColorsManager.darkGrey, fontSize: AppSize.size16),
          titleSmall: getMediumTextStyle(
              color: ColorsManager.darkGrey, fontSize: AppSize.size14),
          bodySmall: getRegularTextStyle(
            color: ColorsManager.grey1,
          ),
          bodyLarge: getRegularTextStyle(color: ColorsManager.grey)),
      inputDecorationTheme: InputDecorationTheme(
          //border
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorsManager.grey1),
          ),
          //hint text style
          hintStyle: getRegularTextStyle(color: ColorsManager.grey1),
          //focused ERROR border
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorsManager.error),
          ),
          //focused border
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorsManager.primary),
          ),
          //focused ERROR hint text style
          errorStyle: getRegularTextStyle(color: ColorsManager.error),
          //focused Label text style
          labelStyle: getMediumTextStyle(color: ColorsManager.grey),

          ///fill COLOR
          filled: true,
          fillColor: ColorsManager.white,
          contentPadding: const EdgeInsets.all(AppPadding.padding8)));
}
