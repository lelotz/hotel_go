import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/font_manager.dart';
import '../../core/resourses/size_manager.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final int maxLines;
  final double size;
  final double height;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextOverflow overFlow;

  const SmallText({Key? key,
    this.color = ColorsManager.darkGrey,
    required this.text,
    this.maxLines = 5,
    this.size = AppSize.size14,
    this.height=1.2,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.w600,
    this.overFlow=TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overFlow,
      style: TextStyle(
          color: color?.withOpacity(0.9),
          fontFamily: FontConstants.fontName,
          fontWeight: fontWeight,
          fontSize:  Size.fromWidth(size).width,
          height: height,
          fontStyle: fontStyle
      ),

    );
  }
}