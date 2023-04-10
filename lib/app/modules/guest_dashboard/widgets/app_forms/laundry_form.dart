import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/buttons/decorated_text_button.dart';
import '../../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../../widgets/inputs/text_field_input.dart';
import '../../../../../widgets/mydividers.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/laundry_form_controller.dart';
import '../tables/display_stored_laundry.dart';
import 'dialog_forms.dart';

class LaundryForm extends GetView<LaundryFormController> {
  LaundryForm({Key? key}) : super(key: key);
  final laundryFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaundryFormController>(
        init: LaundryFormController(),
        builder: (controller) => Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // dialogFormHeader(LocalKeys.kLaundryForm.tr),
                buildFormHeader(LocalKeys.kLaundryForm.tr),
                SizedBox(height: const Size.fromHeight(20).height,),
                /// Receive and Return Buttons
                Obx(() => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DecoratedTextButton(
                              buttonLabel: LocalKeys.kReceive.tr,
                              onPressed: controller.receiveLaundry,
                              backgroundColor: controller.receivingLaundry.value
                                  ? ColorsManager.primaryAccent
                                  : Colors.white24,
                            ),
                            DecoratedTextButton(
                              buttonLabel: LocalKeys.kReturn.tr,
                              onPressed: controller.returnLaundry,
                              backgroundColor: controller.receivingLaundry.value
                                  ? Colors.white24
                                  : ColorsManager.primaryAccent,
                            ),
                          ],
                        ),
                        //SizedBox(height: getHeight(context, 20),),
                        //BigText(text: receivingLaundry ? "Wash Clothes" : '${LocalKeys.kReceive.tr} ${LocalKeys.kLaundry.tr}'),
                        thinDivider(),
                      ],
                    )),

                /// Input Stored Items
                Obx(
                  () => controller.receivingLaundry.value
                      ? Card(
                          child: Form(
                            key: laundryFormKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFieldInput(
                                          textEditingController:
                                              controller.laundryDescriptionCtrl,
                                          hintText: LocalKeys.kClothesGiven.tr,
                                          textInputType: TextInputType.text,
                                          validation: DataValidation.isAlphabeticOnly,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFieldInput(
                                          textEditingController:
                                              controller.laundryQuantityCtrl,
                                          hintText: LocalKeys.kQuantity.tr,
                                          textInputType: TextInputType.text,
                                          validation: DataValidation.isNumeric,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFieldInput(
                                          textEditingController:
                                              controller.laundryPriceCtrl,
                                          hintText: LocalKeys.kCost.tr,
                                          textInputType: TextInputType.text,
                                          validation: DataValidation.isNumeric,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// Save New Item Button
                                ElevatedButton(
                                    onPressed: (){
                                      if(laundryFormKey.currentState!.validate()){
                                        controller.bufferNewStoredLaundry();
                                      }
                                    },
                                    child: SmallText(
                                      text: LocalKeys.kStore.tr,
                                      color: ColorsManager.white,
                                    )),
                                SizedBox(
                                  height: const Size.fromHeight(10).height,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [],
                        ),
                ),

                /// Select HouseKeeping Staff
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Obx(() => controller.receivingLaundry.value
                      ? GeneralDropdownMenu(
                          backgroundColor: ColorsManager.white,
                          menuItems: controller.houseKeepingStaffNames.value,
                          callback: controller.selectHouseKeeper,
                          initialItem: 'Housekeeper')
                      : const SizedBox()),
                ),

                /// Display buffered laundry
                Obx(
                  () => controller.receivingLaundry.value
                      ? const DisplayNewLaundryBuffer()
                      : const SizedBox(),
                ),

                /// Display stored laundry
                Obx(() => controller.returningLaundry.value
                    ? const DisplayStoredLaundry()
                    : const SizedBox()),

                /// Laundry Action and Stored Laundry Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white24),
                              onPressed: () {
                                controller.receivedLaundryBuffer.value.clear();
                                controller.clearLaundryFormInputs();
                                controller.updateUI();
                                Navigator.of(context).pop();
                              },
                              child: SmallText(
                                text: LocalKeys.kCancel.tr,
                                color: ColorsManager.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.receivingLaundry.value
                                    ? controller.storeNewLaundry()
                                    : controller.returnLaundryItems();

                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.receivingLaundry.value
                                      ? controller.receivedLaundryViewCount
                                                  .value >
                                              0
                                          ? BigText(
                                              text: controller
                                                  .receivedLaundryViewCount
                                                  .value
                                                  .toString())
                                          : const SizedBox()
                                      : controller.returnedLaundryBufferCount
                                                  .value >
                                              0
                                          ? BigText(
                                              text: controller
                                                  .returnedLaundryBufferCount
                                                  .value
                                                  .toString())
                                          : const SizedBox(),
                                  SmallText(
                                    text: controller.receivingLaundry.value
                                        ? '${LocalKeys.kReceive.tr} ${LocalKeys.kLaundry.tr}'
                                        : '${LocalKeys.kReturn.tr} ${LocalKeys.kLaundry.tr}',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}

class DisplayNewLaundryBuffer extends GetView<LaundryFormController> {
  const DisplayNewLaundryBuffer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaundryFormController>(
        builder: (controller) => SizedBox(
              height: const Size.fromHeight(300).height,
              child: Obx(() => controller.receivedLaundryBuffer.value.isNotEmpty
                  ? GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                      ),
                      children: List<Widget>.generate(
                          controller.receivedLaundryBufferCount.value, (index) {
                        return Obx(
                          () => Card(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(
                                      text: controller.receivedLaundryBuffer
                                          .value[index].grandTotal
                                          .toString()),
                                  SmallText(
                                      text:
                                          '${LocalKeys.kLaundry.tr}  : ${controller.receivedLaundryBuffer.value[index].transactionNotes.toString().split(':')[1]}'),
                                  SmallText(
                                      text:
                                          '${LocalKeys.kQuantity.tr} : ${controller.receivedLaundryBuffer.value[index].transactionNotes.toString().split(':')[0]}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : const Center(
                      child: BigText(
                        text: '',
                      ),
                    )),
            ));
  }
}
