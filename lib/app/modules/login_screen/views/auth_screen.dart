import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/values/assets.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/buttons/container_text_button.dart';
import '../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../widgets/inputs/text_field_input.dart';
import 'package:get/get.dart';

import '../../user_management/widgets/forms/create_user_form.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  final signInFormKey = GlobalKey<FormState>();
  final AuthController authController =
      Get.put(AuthController(isTest: false), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorsManager.whiteGradiants,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(Assets.kLoginBackground)),
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
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                    color: Color(0x24000000),
                    offset: Offset(0.0, 2.0),
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                    color: Color(0x1f000000),
                    offset: Offset(0.0, 1.0),
                    blurStyle: BlurStyle.normal)
              ],
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Logo
                Container(
                  height: 100,
                  width: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(Assets.kLogo),
                    // fit: BoxFit
                  )),
                ),
                Form(
                  key: signInFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: const Size.fromHeight(50).height,
                        ),
                        TextFieldInput(
                            textEditingController: authController.fullNameCtrl,
                            hintText: LocalKeys.kFullName.tr,
                            textInputType: TextInputType.text,
                            validation: DataValidation.isAlphabeticOnly,
                            title: "Name"),
                        SizedBox(
                          height: const Size.fromHeight(12).height,
                        ),
                        TextFieldInput(
                            textEditingController:
                                authController.adminUserPasswordCtrl,
                            hintText: LocalKeys.kEmployeeId.tr,
                            textInputType: TextInputType.visiblePassword,
                            validation: DataValidation.isNotEmpty,
                            title: "Password"),
                        SizedBox(
                          height: const Size.fromHeight(12).height,
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.padding40, right: AppPadding.padding40),
                  child: Column(
                    children: [
                      ContainerTextButton(
                          onClick: () async {
                            if (signInFormKey.currentState!.validate() &&
                                await authController.validateLoginAttempt()) {
                              await authController.loginUser();
                            }
                          },
                          text: LocalKeys.kLogin.tr,
                          backgroundColor: ColorsManager.darkGrey,
                          textColor: ColorsManager.darkGrey),
                      Obx(() => authController.authResult.value != ''
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SmallText(
                                  text: authController.authResult.value,
                                  color: authController.authResult.value == LocalKeys.kSuccess.toUpperCase() ? ColorsManager.success : ColorsManager.error,
                                ),
                              ),
                            )
                          : const SizedBox())
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.padding40, right: AppPadding.padding40),
                  child: ContainerTextButton(
                      onClick: () {
                        buildDialog(context, 'Create User', CreateUserForm(),
                            width: 400,
                            height: 600,
                            alignment: Alignment.center);
                      },
                      text: 'CREATE USER',
                      backgroundColor: ColorsManager.darkGrey,
                      textColor: ColorsManager.darkGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
