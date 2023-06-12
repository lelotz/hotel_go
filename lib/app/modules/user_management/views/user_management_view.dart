import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_management_controller.dart';
import 'package:hotel_pms/app/modules/user_management/views/user_profile_view.dart';
import 'package:hotel_pms/app/modules/user_management/widgets/forms/create_user_form.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';

import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../widgets/text/small_text.dart';

class UserManagementView extends GetView<UserManagementController> {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
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
                            Expanded(
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.account_balance),
                                    title: SmallText(text: 'Admin',),
                                    subtitle: Obx(() => SmallText(text: controller.adminEmployees.value.length.toString(),fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,)),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.handshake_outlined),
                                    title: SmallText(text: 'Receptionists',),
                                    subtitle: Obx(() => SmallText(text: controller.receptionEmployees.value.length.toString(),fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,)),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.house_sharp),
                                    title: SmallText(text: 'Housekeeping',),
                                    subtitle: Obx(() => SmallText(text: controller.housekeepingEmployees.value.length.toString(),fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,)),
                                  ),
                                ],
                              ),
                            )

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

                            /// Actions & Search Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyOutlinedButton(text: "Add User", onClick:(){
                                  buildDialog(context, 'Create User', CreateUserForm(),width: 400,height: 550,alignment: Alignment.center);
                                  },
                                  width: 120,height: 40,
                                  backgroundColor: ColorsManager.primary,borderColor: ColorsManager.primary,
                                ),
                                SizedBox(
                                  width: 300,
                                  child: TextFieldInput(
                                    inputFieldWidth: 250,
                                    inputFieldHeight: 50,
                                    textEditingController: controller.searchController,
                                    hintText: "Search",
                                    textInputType: TextInputType.text,
                                    useBorder: true,
                                    useIcon: true,
                                    icon: Icons.search,
                                  ),
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
                                  DataColumn(label: BigText(text: 'Full name',)),
                                  DataColumn(label: BigText(text: 'Position',)),
                                  DataColumn(label: BigText(text: 'Rooms sold/Laundry Washed',)),
                                  DataColumn(label: BigText(text: 'Phone',)),
                                  DataColumn(label: BigText(text: 'Id',)),

                                ],
                                rows: List<DataRow>.generate(controller.allEmployees.value.length, (index) {
                                  return DataRow(
                                    onLongPress: (){
                                      controller.selectedUser.value = controller.allEmployees.value[index];
                                      Get.to(()=>UserProfileView());
                                    },
                                      cells: [
                                        DataCell(BigText(text: (index+1).toString(),)),
                                        DataCell(SmallText(text: controller.allEmployees.value[index].fullName!,)),
                                        DataCell(SmallText(text: controller.allEmployees.value[index].position!,)),
                                        DataCell(SmallText(text: controller.allEmployees.value[index].roomsSold.toString(),)),
                                        DataCell(SmallText(text: controller.allEmployees.value[index].phone!,)),
                                        DataCell(SmallText(text: controller.allEmployees.value[index].id!,)),
                                      ]
                                  );
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
