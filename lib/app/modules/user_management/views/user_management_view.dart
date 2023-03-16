import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_management_controller.dart';
import 'package:hotel_pms/app/modules/user_management/widgets/forms/create_user_form.dart';
import 'package:hotel_pms/app/modules/widgtes/admin_card_popup_actions.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../widgets/buttons/myElevatedButton.dart';
import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../widgets/text/title_subtitle.dart';

class UserManagementView extends GetView<UserManagementController> {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double currentHeight = MediaQuery.of(context).size.height;
    return GetBuilder<UserManagementController>(
      init: UserManagementController(),
        builder: (controller)=>Scaffold(
        appBar: buildGlobalAppBar(context,appBarTitle: "User Management"),
        body: SafeArea(
          child: SizedBox(
            width: currentWidth,

            child: ConstrainedBox(
              constraints: BoxConstraints.loose(const Size.fromWidth(1920)),
              child: Row(
                children: [
                  /// SideBar
                  Expanded(
                    flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: const Size.fromWidth(AppPadding.padding20).width,
                            vertical: const Size.fromHeight(AppPadding.padding20).height),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                BigText(text: "Employees"),
                                Icon(Icons.people_alt_outlined)
                              ],
                            ),
                            thinDivider(),
                            const LabeledText(title: "All Employees", subtitle: '10',dividerHeight: 6,switchProperties: true,),
                            InkWell(
                              onTap: (){},
                                child: Row(
                                  children: const [
                                    LabeledText(title: "Receptionists", subtitle: '3',dividerHeight: 6,switchProperties: true),
                                  ],
                                )
                            ),
                            InkWell(
                                onTap: (){},
                                child: Row(
                                  children: const [
                                    LabeledText(title: "Housekeeping", subtitle: '3',dividerHeight: 6,switchProperties: true),
                                  ],
                                )
                            ),
                            InkWell(
                                onTap: (){},
                                child: Row(
                                  children: const [
                                    LabeledText(title: "Restaurant", subtitle: '4',dividerHeight: 6,switchProperties: true),
                                  ],
                                )
                            ),

                          ],
                        ),
                      )),
                  Container(
                    height: const Size.fromHeight(1000).height,
                    width: 1,
                    color: ColorsManager.lightGrey,
                  ),

                  Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            /// Title
                            const BigText(text: "Manage employees"),
                            SizedBox(height: const Size.fromHeight(20).height,),

                            /// Actions & Search Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyOutlinedButton(text: "Add User", onClick:(){
                                  buildDialog(context, 'Create User',const CreateUserForm(),width: 400,height: 600,alignment: Alignment.center);
                                  },
                                  width: 120,height: 40,
                                  backgroundColor: ColorsManager.primary,borderColor: ColorsManager.primary,
                                ),
                                MyOutlinedButton(
                                  text: "Settings", onClick: (){},
                                  backgroundColor: ColorsManager.flutterGrey,textColor: ColorsManager.darkGrey,currentTextColor: ColorsManager.darkGrey,borderColor: ColorsManager.primary,
                                  height: 40,width: 100,borderRadius: AppBorderRadius.radius8,
                                ),
                                MyOutlinedButton(
                                  text: "Settings", onClick: (){},
                                  backgroundColor: ColorsManager.flutterGrey,textColor: ColorsManager.darkGrey,currentTextColor: ColorsManager.darkGrey,borderColor: ColorsManager.primary,
                                  height: 40,width: 100,borderRadius: AppBorderRadius.radius8,
                                ),
                                MyOutlinedButton(
                                  text: "Settings", onClick: (){},
                                  backgroundColor: ColorsManager.flutterGrey,textColor: ColorsManager.darkGrey,currentTextColor: ColorsManager.darkGrey,borderColor: ColorsManager.primary,
                                  height: 40,width: 100,borderRadius: AppBorderRadius.radius8,
                                ),
                                TextFieldInput(
                                  inputFieldWidth: 250,
                                  inputFieldHeight: 50,
                                  textEditingController: controller.searchController,
                                  hintText: "Search",
                                  textInputType: TextInputType.text,
                                  useBorder: true,
                                  useIcon: true,
                                  icon: Icons.search,
                                )
                              ],
                            ),

                            SizedBox(height: const Size.fromHeight(20).height,),
                            ///Table
                            Obx(() => Center(
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith((states) => ColorsManager.primaryAccent.withOpacity(0.4)),
                                showCheckboxColumn: true,
                                columns: const [
                                  DataColumn(label: BigText(text: '#',)),
                                  DataColumn(label: BigText(text: 'full name',)),
                                  DataColumn(label: BigText(text: 'position',)),
                                  DataColumn(label: BigText(text: 'rooms sold',)),
                                  DataColumn(label: BigText(text: 'phone',)),
                                  DataColumn(label: BigText(text: 'id',)),

                                ],
                                rows: List<DataRow>.generate(controller.allEmployees.value.length, (index) {
                                  return DataRow(
                                      cells: [
                                        DataCell(BigText(text: (index+1).toString(),)),
                                        DataCell(BigText(text: controller.allEmployees.value[index].fullName!,)),
                                        DataCell(BigText(text: controller.allEmployees.value[index].position!,)),
                                        DataCell(BigText(text: controller.allEmployees.value[index].roomsSold.toString(),)),
                                        DataCell(BigText(text: controller.allEmployees.value[index].phone!,)),
                                        DataCell(BigText(text: controller.allEmployees.value[index].appId!,)),
                                      ]);
                                }
                                ),
                              ),
                            ))
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
    ));
  }
}
