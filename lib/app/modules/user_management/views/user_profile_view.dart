import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/confirm_and_status_dialogs/view/confirm_dialog_view.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/app/modules/user_management/tables/table/employee_activity_table_view.dart';
import 'package:hotel_pms/app/modules/user_management/widgets/forms/user_profile_summary.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/mydividers.dart';

import '../../../../core/resourses/color_manager.dart';
import '../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../widgets/text/small_text.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
        builder: (controller)=> Scaffold(
          appBar: buildGlobalAppBar(context,appBarTitle: 'User Profile'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    controller.adminUser.value.status == 'DISABLED' ?  ElevatedButton(
                        onPressed: ()async{
                          buildDialog(context,'',ConfirmDialog(
                            separator: ':',
                            onConfirmed: ()async{
                              await controller.updateAccountStatus('ENABLED');
                              Navigator.of(Get.overlayContext!).pop();
                            },
                            confirmText:
                            '''Name : ${controller.adminUser.value.fullName}''',
                            confirmTitle: 'Enable User Account?',
                          ),height: 170,width: 300);
                        },
                        child: const SmallText(text: 'Enable Account',color: ColorsManager.grey2,)):

                    ElevatedButton(
                        onPressed: ()async{
                          buildDialog(context,'',ConfirmDialog(
                              separator: ':',
                              onConfirmed: ()async{
                                await controller.updateAccountStatus('DISABLED');
                                Navigator.of(Get.overlayContext!).pop();
                              },
                              confirmText:
                              '''Name : ${controller.adminUser.value.fullName}''',
                            confirmTitle: 'Disable User Account?',
                          ),height: 170,width: 300);
                        },
                        child: const SmallText(text: 'Disable Account',color: ColorsManager.grey2,)),
                  ],
                ),
                thinDivider(),
                Row(
                  children: [
                    /// Profile Summary Card
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          UserProfileSummaryView()
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                        child: Column(
                        children: [
                        controller.initialized ? EmployeeTableView() : loadingAnimation(actionStatement: 'Loading')
                      ],
                    ))

                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
