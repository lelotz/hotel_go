import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/controller/form_selector_controller.dart';
import 'package:hotel_pms/app/modules/room_data_screen/widgets/app_forms/dialog_forms.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:get/get.dart';



class FormSelector extends GetView<FormSelectorController> {
  const FormSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormSelectorController>(
      init: FormSelectorController(),
      builder:  (controller)=> GeneralDropdownMenu(
                  menuItems: controller.formNames.value,
                  callback:(formName){
                    controller.selectedForm(formName);
                    controller.getSelectedForm(context, formName);
                  },
                  initialItem: "Forms",backgroundColor: ColorsManager.primary,borderRadius: 8,
        hintTextColor: ColorsManager.white,
        userBorder: false,
      )
    );

  }

}
