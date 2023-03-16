

import 'dart:math';

import 'package:flutter/cupertino.dart';


/// Dev Height = 745.599975
/// Dev Width = 1536
class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
class MySize{
  double height;
  double width;
  MySize(this.width,this.height);
}
MySize devSize = MySize(1536, 745.599975);


