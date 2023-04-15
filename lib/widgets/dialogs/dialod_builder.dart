import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';

import '../../core/resourses/size_manager.dart';
import '../forms/form_header.dart';
buildDialog(BuildContext context,String formName, Widget widget,{double height = 300,double width=200,AlignmentGeometry alignment = Alignment.center,Color backgroundColor=ColorsManager.white})async{
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return  Dialog(
          alignment: alignment,
          elevation: 10,
          child:  Container(
            height: Size.fromHeight(height).height,
            width:  Size.fromWidth(width).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.radius16),
              color: backgroundColor,
            ),
            child: formName == '' ? widget : Column(
              children: [
                buildFormHeader(formName),
                widget,
              ],
            ),
          )
      );
    },
  ).catchError((onError){
    print(onError);
  });
}

buildStatusDialog(BuildContext context, Widget widget,{AlignmentGeometry alignment = Alignment.center})async{
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return  Dialog(
          alignment: alignment,
          elevation: 10,
          child: widget
      );
    },
  );
}