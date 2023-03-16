import 'package:flutter/material.dart';

import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';


class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroungColor;
  final double iconSize;
  final double size;
  final bool useBackground;

  const AppIcon({Key? key,
    required this.icon,
    this.backgroungColor = ColorsManager.flutterGrey,
    this.iconColor = ColorsManager.darkGrey,
    this.iconSize = AppSize.size24,
    this.size = AppSize.size40,
    this.useBackground = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(useBackground ? size : 0),
        color: backgroungColor,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
