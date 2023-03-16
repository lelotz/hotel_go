
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/resourses/color_manager.dart';


Widget loadingAnimation({Color loadingColor = ColorsManager.primaryAccent,double size=200}){
  return Center(
      child: LoadingAnimationWidget.stretchedDots(
        color: loadingColor,
        size: size,
      ));
}