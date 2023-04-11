
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/buttons/myElevatedButton.dart';

import '../../../core/resourses/color_manager.dart';
import '../../../core/values/localization/local_keys.dart';
import '../../../widgets/buttons/my_outlined_button.dart';
import '../../../widgets/text/small_text.dart';
import '../login_screen/controller/auth_controller.dart';
import 'package:get/get.dart';


class AdminCardPopUp extends StatelessWidget {
  AdminCardPopUp({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(child:
            ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: SmallText(text: 'Profile',),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: SmallText(text: 'Settings',),
                ),
                ListTile(
                  hoverColor: ColorsManager.primaryAccent.withOpacity(0.9),
                  leading: Icon(Icons.logout),
                  title: SmallText(text: 'Logout',),
                  onTap: ()async{await authController.logOutUser();},
                ),

              ],
            )
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: MyOutlinedButton(
        //         text: LocalKeys.kLogOut.tr, onClick: ()async{await authController.logOutUser();},
        //         width: 100,
        //         height: 50,
        //
        //       ),
        //     ),
        //   ],
        // ),
        // authController.displayLogOutError.value ?
        // MyElevatedButton(
        //     text: authController.logOutResult.value,
        //     backgroundColor: ColorsManager.error,
        //     onPressed: (){}) : const SizedBox(),
      ],
    );
  }
}







