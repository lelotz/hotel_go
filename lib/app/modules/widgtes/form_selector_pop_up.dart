import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/controller/form_selector_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
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
