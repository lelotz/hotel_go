
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/buttons/myElevatedButton.dart';

import '../../../core/resourses/color_manager.dart';
import '../../../core/resourses/size_manager.dart';
import '../../../widgets/buttons/my_outlined_button.dart';
import '../login_screen/controller/auth_controller.dart';
import 'package:get/get.dart';


class AdminCardPopUp extends StatelessWidget {
  AdminCardPopUp({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyOutlinedButton(
                text: 'Logout', onClick: (){authController.logOutUser();},
                width: 100,
                height: 50,

              ),
            ),
          ],
        ),
        authController.displayLogOutError.value ?
        MyElevatedButton(
            text: authController.logOutResult.value,
            backgroundColor: ColorsManager.error,
            onPressed: (){}) : const SizedBox(),
      ],
    );
  }
}







