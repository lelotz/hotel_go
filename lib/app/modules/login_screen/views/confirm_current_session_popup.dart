import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/core/values/localization/messages.dart';
import 'package:hotel_pms/widgets/buttons/card_button.dart';
import 'package:hotel_pms/widgets/images/display_image.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/values/assets.dart';


class ConfirmCurrentSession extends GetView<SessionManager> {
  const ConfirmCurrentSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionManager>(builder: (controller)=>Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: displayImage(asset: Assets.kDeskOne,fit: BoxFit.cover,borderRadius: 4)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Size.fromWidth(20).width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // displayImage(asset: Assets.kLogo,height: 70),
                  SizedBox(
                    height: Size.fromHeight(220).height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SmallText(text: AppMessages.welcomeBack.tr),
                            BigText(text: controller.userData.userData.value[controller.currentSession.value.employeeId])
                          ],
                        ),
                        SmallText(text: AppMessages.sessionRestorationMessage.tr),
                        SizedBox(height: Size.fromHeight(40).height,),
                        SmallText(text: 'Shift hii iliorejeshwa ilianza :'),
                        SmallText(text: '${extractDate(null,dateFromString: controller.currentSession.value.dateCreated)}'),
                        SmallText(text: '${extractTime(DateTime.parse(controller.currentSession.value.dateCreated ?? ''))}'),


                      ],
                    ),
                  ),
                  CardButton(onPressed: (){
                    Navigator.pop(Get.overlayContext!);
                  }, text: LocalKeys.kContinue.tr,backgroundColor: ColorsManager.primaryAccent,textColor: ColorsManager.white,),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

