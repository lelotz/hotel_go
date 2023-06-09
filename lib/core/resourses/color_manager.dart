import 'package:flutter/material.dart' ;

class ColorsManager {
  static const Color primary = Color(0xFF2a3035);
  static const Color primaryAccent = Color(0xFF56bff0);
  static const Color darkGrey = Color(0xFF484859);
  static const Color flutterGrey = Color(0xFFf7f5f5);
  static const Color grey = Color.fromARGB(255, 163, 163, 163);
  static const Color transparent = Color.fromARGB(100, 22, 44, 33);

  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color grey1 = Color(0xFFF5F5F5);
  static const Color grey2 = Color(0xFFEEEEEE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF39d078);
  static const Color red = Color(0xFFFF0000);
  static const Color black = Color(0xFF000019);
  static const LinearGradient simpleGradients = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3548AE),
      Color(0xFFA324D6),
    ],
    stops: [0.3, 0.7],
  );
  static const LinearGradient whiteGradients = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightGrey,
      primary,


    ],
    stops: [0.3, 0.7],
  );
  static const LinearGradient multiGradiants = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF13B1AD),
      Color(0xFFD52DF2),
    ],
    stops: [0.1, 0.9],
  );
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF13B1AD),
      Color(0xff4414A4),
      Color(0xFFD52DF2),
    ],
    stops: [0.1, 0.5, 0.9],
  );
}
