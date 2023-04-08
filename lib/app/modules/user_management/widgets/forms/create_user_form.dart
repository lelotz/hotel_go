import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/user_management/controller/create_new_user_form_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/widgets/buttons/myElevatedButton.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';


class CreateUserForm extends GetView<CreateUserController> {
  CreateUserForm({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateUserController>(
        init: CreateUserController(),
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Form
            Form(
              key: formKey,
              child: Column(
                children: [
                  /// Heading
                  // buildFormHeader('Create Employee'),

                  /// Input FullName
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 40, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldInput(
                            inputFieldWidth:
                                const Size.fromWidth(180).width,
                            textEditingController:
                                controller.fullNameController,
                            hintText: "Full Name",
                            textInputType: TextInputType.text,
                            useBorder: true,
                            validation: DataValidation.isAlphabeticOnly,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Input Phone number
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldInput(
                            inputFieldWidth:
                                const Size.fromWidth(180).width,
                            textEditingController:
                                controller.phoneController,
                            hintText: "Phone number",
                            textInputType: TextInputType.text,
                            useBorder: true,
                            validation: DataValidation.isNumeric,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Input Position
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 10),
                          child: GeneralDropdownMenu(
                              menuItems: controller.userPositions,
                              callback: controller.setUserPosition,
                              initialItem: "Position"),
                        ),
                      ),
                     ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 10),
                          child: TextFieldInput(
                            textEditingController: controller.userIdController,
                            hintText: 'User id',
                            validation: DataValidation.isNotEmpty,
                          ),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),

            /// Cancel and Save buttons
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyElevatedButton(
                    text: "Cancel",
                    onPressed: () {
                      //buildStatusDialog(Get.context!, confirmAlert("COnfrim", "subtitle"));
                      Navigator.of(Get.overlayContext!).pop();
                    },
                    backgroundColor: ColorsManager.flutterGrey,
                    textColor: ColorsManager.darkGrey,
                  ),
                  MyElevatedButton(
                    text: "Create User",
                    onPressed: ()async{
                      if(formKey.currentState!.validate()){
                        await controller.createNewEmployee();
                      }
                    },
                    backgroundColor:
                    ColorsManager.primaryAccent.withOpacity(0.7),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
