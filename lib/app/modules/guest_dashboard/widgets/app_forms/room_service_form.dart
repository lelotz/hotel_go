import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/core/values/assets.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';
import 'package:hotel_pms/widgets/images/display_image.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/resourses/size_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/room_service_controller.dart';

class RoomServiceForm extends GetView<RoomServiceFormController> {
  RoomServiceForm({Key? key}) : super(key: key);
  final roomServiceFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomServiceFormController>(
        init: RoomServiceFormController(),
        builder: (controller) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Dialog Form Header
                    /// Includes Room Number, Status, Guest Name, and Form Title
                    // dialogFormHeader(LocalKeys.kRoomService.tr),
                    buildFormHeader(LocalKeys.kRoomService.tr),
                    SizedBox(
                      height: const Size.fromHeight(20).height,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: roomServiceFormKey,
                          child: Column(
                            children: [
                              Flex(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                direction: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextFieldInput(
                                        textEditingController:
                                            controller.serviceDescription,
                                        hintText: LocalKeys.kRoomService.tr,
                                        textInputType: TextInputType.text,
                                      validation: DataValidation.isAlphabeticOnly,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: TextFieldInput(
                                        textEditingController:
                                            controller.serviceCost,
                                        hintText: LocalKeys.kCost.tr,
                                        textInputType: TextInputType.text,
                                      validation: DataValidation.isNumeric,
                                    ),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if(roomServiceFormKey.currentState!.validate()){
                                      await controller.addRoomServiceToBuffer();
                                    }
                                  },
                                  child: SmallText(
                                      text: LocalKeys.kStore.tr,
                                      color: ColorsManager.white)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const DisplayRoomServiceBuffer(),
                  ],
                ),

                /// Key Action and Stored Item Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    direction: Axis.horizontal,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            controller.clearFormInputs();
                            controller.receivedRoomServiceBuffer.value.clear();
                            Navigator.of(Get.overlayContext!).pop();
                          },
                          child: SmallText(
                            text: LocalKeys.kCancel.tr,
                            color: ColorsManager.white,
                          )),
                      ElevatedButton(
                          onPressed: () async {
                            await controller.storeRoomServices();
                            Navigator.of(context).pop();
                          },
                          child: SmallText(
                              text: LocalKeys.kReceive.tr,
                              color: ColorsManager.white)),
                    ],
                  ),
                ),
              ],
            ));
  }
}

class DisplayRoomServiceBuffer extends GetView<RoomServiceFormController> {
  const DisplayRoomServiceBuffer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomServiceFormController>(
        init: RoomServiceFormController(),
        builder: (controller) => SizedBox(
            height: const Size.fromHeight(AppSize.size150 * 1.5).height,
            child: Obx(() => controller.roomServiceBufferCount.value > 0
                ? GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3,
                    ),
                    children: List<Widget>.generate(
                        controller.roomServiceBufferCount.value, (index) {
                      return Builder(builder: (BuildContext context) {
                        return Obx(() => Card(
                              child: Center(
                                child: Column(
                                  children: [
                                    BigText(
                                        text: controller
                                            .receivedRoomServiceBuffer
                                            .value[index]
                                            .grandTotal
                                            .toString()),
                                    SmallText(
                                        text: controller
                                            .receivedRoomServiceBuffer
                                            .value[index]
                                            .transactionNotes
                                            .toString())
                                  ],
                                ),
                              ),
                            ));
                      });
                    }),
                  )
                : displayImage(asset: Assets.kRoomService))));
  }
}
