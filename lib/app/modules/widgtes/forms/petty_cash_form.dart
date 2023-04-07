import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/text/small_text.dart';
import '../../controller/petty_cash_form_controller.dart';

class PettyCashForm extends GetView<PettyCashFormController> {
  PettyCashForm({Key? key}) : super(key: key);

  final pettyCashFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PettyCashFormController>(
        init: PettyCashFormController(),
        builder: (controller) =>
            Form(
                key: pettyCashFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldInput(
                                    textEditingController:
                                    controller.beneficiaryNameCtrl,
                                    hintText: "Name",
                                    useBorder: true,
                                    validation: DataValidation.isAlphabeticOnly,
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx(() =>
                                        GeneralDropdownMenu(
                                          menuItems: controller.departments,
                                          callback: controller.setDepartment,
                                          initialItem: 'Department',
                                          borderColor: controller
                                              .selectedDepartmentStatus.value ==
                                              ''
                                              ? ColorsManager.darkGrey
                                              : ColorsManager.red,

                                        )))),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldInput(
                                    textEditingController:
                                    controller.transactionValueCtrl,
                                    hintText: "Value",
                                    useBorder: true,
                                    validation: DataValidation.isNumeric,
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldInput(
                                    textEditingController: controller
                                        .descriptionCtrl,
                                    hintText: "Description".toUpperCase(),
                                    useBorder: true,
                                    maxLines: 10,
                                    validation: DataValidation.isAlphabeticOnly,
                                  ),
                                )),
                          ],
                        ),
                      ]),
                      Obx(() =>
                          Card(
                            child: InkWell(
                              onTap: () async {
                                if (pettyCashFormKey.currentState!.validate() &&
                                    controller.validateSelectedDepartment()) {
                                  await controller.createPettyCashForm();
                                  Navigator.of(Get.overlayContext!).pop();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: controller.creatingTransaction.value
                                    ? loadingAnimation(
                                    actionStatement: 'Creating', size: 50)
                                    : Column(
                                  children: [
                                    SmallText(text: LocalKeys.kSubmit.tr),
                                    controller.selectedDepartmentStatus.value
                                        .isNotEmpty ? SmallText(
                                      text: controller.selectedDepartmentStatus
                                          .value, color: ColorsManager.error,): const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )));
  }
}
