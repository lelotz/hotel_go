

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/user_management/controller/create_new_user_form_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/buttons/myElevatedButton.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../../widgets/dialogs/activity_status_dialog.dart';
import '../../../../../widgets/dialogs/dialod_builder.dart';

class CreateUserForm extends GetView<CreateUserController> {
  const CreateUserForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateUserController>(
      init: CreateUserController(),
        builder: (controller)=>Form(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Column(
            children: [
              /// Heading
              Container(
                color: ColorsManager.primaryAccent.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  child: Row(

                    children:  [
                      const BigText(text: "Create Employee",size: 18,),
                      SizedBox(width: const Size.fromWidth(170).width,),
                      InkWell(onTap: (){Navigator.of(Get.overlayContext!).pop();},child: const Icon(Icons.close))
                    ],
                  ),
                ),
              ),

              /// Input FullName
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldInput(
                        inputFieldWidth: const Size.fromWidth(180).width,
                        textEditingController: controller.fullNameController,
                        hintText: "Full Name",
                        textInputType: TextInputType.text,
                        useBorder: true,
                      ),
                    ),
                  ],
                ),
              ),

              /// Input Phone number
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldInput(
                        inputFieldWidth: const Size.fromWidth(180).width,
                        textEditingController: controller.phoneController,
                        hintText: "Phone number",
                        textInputType: TextInputType.text,
                        useBorder: true,
                      ),
                    ),
                  ],
                ),
              ),

              /// Input Position
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
                child: GeneralDropdownMenu(menuItems: controller.userPositions, callback: controller.setUserPosition, initialItem: "Position"),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 1),
                child: SmallText(text: "User Id"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
                child: MyElevatedButton(text: controller.newUserId.value, onPressed: (){},

                ),
              ),
            ],
          ),


          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyElevatedButton(text: "Cancel", onPressed: (){
                  //buildStatusDialog(Get.context!, confirmAlert("COnfrim", "subtitle"));
                  Navigator.of(Get.overlayContext!).pop();
                },backgroundColor: ColorsManager.flutterGrey,textColor: ColorsManager.darkGrey,),
                MyElevatedButton(text: "Create User", onPressed: controller.createNewEmployee,backgroundColor:ColorsManager.primaryAccent.withOpacity(0.7),),

              ],
            ),
          )





        ],
      ),
    ));
  }
}
