
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/resourses/color_manager.dart';
import '../text/big_text.dart';


Widget loadingAnimation({Color loadingColor = ColorsManager.primaryAccent,double size=200, String actionStatement="Loading"}){
  return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigText(text: actionStatement),
          LoadingAnimationWidget.stretchedDots(
            color: loadingColor,
            size: size,
          ),
        ],
      ));
}