import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/app/modules/user_management/controller/create_new_user_form_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import '../../../../core/utils/dim_logic.dart';
import '../../../../core/values/assets.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/buttons/container_text_button.dart';
import '../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../widgets/inputs/text_field_input.dart';
import 'package:get/get.dart';

import '../../user_management/widgets/forms/create_user_form.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController(),permanent: true);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: ColorsManager.whiteGradiants,
        ),
        child: Center(
          /// Login Form
          child: Container(
            width: const Size.fromWidth(280).width,
            height: const Size.fromHeight(420).height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: ColorsManager.primary,
                    offset: Offset(0.0, 3.0),
                    blurStyle: BlurStyle.normal
                ),
                BoxShadow(color: Color(0x24000000),
                    offset: Offset(0.0, 2.0), blurStyle: BlurStyle.normal),
                BoxShadow(color: Color(0x1f000000),
                    offset: Offset(0.0, 1.0), blurStyle: BlurStyle.normal)
              ],

              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.1, 1,]),


            ),

            alignment: Alignment.bottomCenter,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Logo
                Container(
                  height:  100,
                  width:  250,
                  decoration:  const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.kLogo))),
                ),
                Column(
                  children: [
                    SizedBox(height: const Size.fromHeight(50).height,),
                    TextFieldInput(textEditingController: authController.fullNameCtrl, hintText: LocalKeys.kFullName.tr, textInputType: TextInputType.text,title: "Email/Phone Number"),
                    SizedBox(height: const Size.fromHeight(12).height,),
                    TextFieldInput(textEditingController: authController.adminUserPasswordCtrl, hintText: LocalKeys.kEmployeeId.tr, textInputType: TextInputType.visiblePassword,title: "Password"),
                    SizedBox(height: const Size.fromHeight(12).height,),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.padding40,right: AppPadding.padding40),
                  child: ContainerTextButton(
                    onClick: authController.authenticateAdminUser,
                    text: LocalKeys.kLogin.tr,backgroundColor: ColorsManager.darkGrey,
                    textColor: ColorsManager.darkGrey
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.padding40,right: AppPadding.padding40),
                  child: ContainerTextButton(
                      onClick: (){
                        buildDialog(context,'Create User', const CreateUserForm(),width: 400,height: 600,alignment: Alignment.center);
                      },
                      text:'CREATE USER',backgroundColor: ColorsManager.darkGrey,
                      textColor: ColorsManager.darkGrey
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
