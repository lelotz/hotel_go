import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/homepage_screen/views/homepage_view.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/app/modules/widgtes/admin_card_popup_actions.dart';
import '../../app/modules/homepage_screen/controller/homepage_controller.dart';
import '../../app/modules/login_screen/controller/auth_controller.dart';
import '../../core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../../core/values/localization/local_keys.dart';
import '../../core/values/localization/localization_controller.dart';
import '../buttons/my_outlined_button.dart';
import '../cards/admin_user_card.dart';
import '../dialogs/dialod_builder.dart';
import '../text/big_text.dart';
import 'package:get/get.dart';

PreferredSizeWidget buildGlobalAppBar(BuildContext context,
    {String appBarTitle = "Whitemark Hotels",
    Color statusColor = ColorsManager.primaryAccent,
    void Function()? onTitleTap,
      void Function()? onBackButton
    }) {
  LocalizationController langController = Get.find<LocalizationController>();
  //HomepageController homepageController = Get.find<HomepageController>();
  AuthController authController = Get.find<AuthController>();
  return AppBar(
    toolbarHeight: 85,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: ColorsManager.grey1,
      ),
      onPressed: () {
        if (appBarTitle == "Whitemark Hotels") {
          Get.to(() => LandingPage());
        } else {
          if(onBackButton!=null){
            onBackButton();
          }else{
            Get.back();
          }

        }
      },
    ),
    title: Obx(
      () => buildAppBarTitle(appBarTitle,
          onTitleTap: onTitleTap,
          statusColor: getAppBarStatusColor(
              sessionExists:
                  authController.sessionController.sessionExists.value)),
    ),
    actions: [
      FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: const Size.fromWidth(AppSize.size4).width,
            ),
            MyOutlinedButton(
              text: 'SW',
              onClick: langController.changeLocaleToSwahili,
              width: 80,
              height: 40,
            ),
            MyOutlinedButton(
              text: 'EN',
              onClick: langController.changeLocaleToEnglish,
              width: 80,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: InkWell(
                  onTap: () {
                    buildDialog(context, '', AdminCardPopUp(),
                        alignment: Alignment.topRight,height: 175
                    );
                  },
                  child: AdminUserCard(),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget buildAppBarTitle(String title,
    {Color statusColor = ColorsManager.primaryAccent,
    void Function()? onTitleTap}) {
  //print('$title ${title.length}');
  return Column(
    children: [
      InkWell(
          onTap: onTitleTap ?? () {},
          child: BigText(
            text: title,
            color: ColorsManager.white,
          )),
      Container(
        width: Size.fromWidth(getTitleAccentColorWidth(title.length)).width,
        height: const Size.fromHeight(5).height,
        color: statusColor,
      )
    ],
  );
}

double getTitleAccentColorWidth(int titleLength) => titleLength / 0.5;

Color getAppBarStatusColor({bool? sessionExists}) {
  switch (sessionExists) {
    case null:
      return ColorsManager.error;
    case true:
      return ColorsManager.primaryAccent;
    case false:
      return ColorsManager.success;
    default:
      return ColorsManager.error;
  }
}
