import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import '../../core/resourses/color_manager.dart';
import '../../core/values/localization/local_keys.dart';

import '../text/big_text.dart';
import '../text/small_text.dart';
import 'package:get/get.dart';

class AdminUserCard extends GetView<AuthController> {
  String title;
  Color? borderColor;
  Color? titleColor;
  Color? subtitleColor;


  AdminUserCard({Key? key,
    this.title = LocalKeys.kLoggedInAs,
    this.borderColor = ColorsManager.white,
    this.subtitleColor = ColorsManager.primaryAccent,
    this.titleColor = ColorsManager.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
        builder: (controller)=>Padding(
        padding: EdgeInsets.only(top: const Size.fromHeight(8).height),
        child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
        ),
        child: FittedBox(
          child: Padding(
            padding:  EdgeInsets.only(left: const Size.fromWidth(8).width,right: const Size.fromWidth(8).width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigText(text: title.tr,color: titleColor,),
                SmallText(text: "${controller.adminUser.value.fullName} (${controller.adminUser.value.position})",color: subtitleColor,),
                //SizedBox(height: const Size.fromHeight(8).height,)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
