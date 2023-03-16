import 'package:flutter/material.dart';


import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/number_formatter.dart';
import '../../core/resourses/font_manager.dart';
import '../../core/resourses/size_manager.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final bool linehtrough;
  final int maxLines;
  final double size;
  final double height;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextOverflow overFlow;
  final bool isNumber;

  const BigText({Key? key,
    required this.text,
    this.isNumber = false,
    this.color = ColorsManager.darkGrey,
    this.linehtrough = false,
    this.maxLines = 5,
    this.size = AppSize.size16,
    this.height= AppSize.size4/3,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.bold,
    this.overFlow=TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isANumber = RegExp(r'^[0-9]+$').hasMatch(text);
    return Text(
      isANumber ? formatNumber(text) : text,
      maxLines: maxLines,
      overflow: overFlow,
      //strutStyle: StrutStyle(),
      style: TextStyle(
        decoration: linehtrough ? TextDecoration.lineThrough : TextDecoration.none,
          color: color,
          fontFamily: FontConstants.fontName,
          fontWeight: fontWeight,
          fontSize: Size.fromWidth(size).width,
          height: height,
          fontStyle: fontStyle
      ),

    );
  }
}