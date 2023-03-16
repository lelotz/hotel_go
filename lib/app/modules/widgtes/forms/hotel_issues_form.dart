import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/controller/hotel_issue_form_controller.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';

import '../../../../widgets/buttons/my_outlined_button.dart';
class HotelIssuesForm extends GetView<HotelIssuesFormController> {
  const HotelIssuesForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HotelIssuesFormController>(
      init: HotelIssuesFormController(),
        builder: (controller)=>Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(()=>
                        GeneralDropdownMenu(
                          menuItems: controller.allRooms.value, callback: controller.setRoomNumber,borderRadius: 4,
                          initialItem: 'Room Number',)
                    ),
                  ),
                  SizedBox(width: const Size.fromWidth(20).width,),

                  Expanded(
                    child: GeneralDropdownMenu(
                      menuItems: controller.hotelIssueTypes, callback: controller.setHotelIssueType,borderRadius: 4,
                      initialItem: 'Issue Type',),
                  )
                ],
              ),
              SizedBox(height: const Size.fromHeight(20).height,),

              Row(
                children: [Expanded(child: TextFieldInput(textEditingController: controller.issueDescription, hintText: "Description"))],
              ),

              Row(
                children: [Expanded(child: TextFieldInput(textEditingController: controller.stepsTakenDescription, hintText: "Steps Taken",maxLines: 5,))],
              ),
              SizedBox(height: const Size.fromHeight(20).height,),

              Row(
                children: [Expanded(child: GeneralDropdownMenu(menuItems: controller.hotelIssueStatusType, callback: controller.setHotelIssueStatus, initialItem: 'Status'))],
              ),
              SizedBox(height: const Size.fromHeight(150).height,),

              Center(child: controller.creatingIssue.value ? loadingAnimation() : MyOutlinedButton(text: 'Submit', onClick: controller.createHotelIssue,))

              ],
          ),
        )
    );
  }
}
