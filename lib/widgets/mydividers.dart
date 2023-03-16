
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';



Divider thickDivider(){
  return const Divider(
    color: ColorsManager.lightGrey,
    thickness: AppSize.size4/2,
    height: AppSize.size24,
  );
}
Divider thinDivider(){
  return const Divider(
    color: ColorsManager.lightGrey,
    thickness: 2,
    //height: AppSize.size24,
  );
}