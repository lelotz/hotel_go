import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/resourses/size_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/room_service_controller.dart';
import 'dialog_forms.dart';



class RoomServiceForm extends GetView<RoomServiceFormController> {

  RoomServiceForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomServiceFormController>(
      init: RoomServiceFormController(),
        builder: (controller)=>
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Dialog Form Header
                /// Includes Room Number, Status, Guest Name, and Form Title
                dialogFormHeader(LocalKeys.kRoomService.tr),

                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
                    TextFieldInput(
                        textEditingController: controller.serviceDescription,
                        hintText: LocalKeys.kRoomService.tr,
                        textInputType: TextInputType.text
                    ),
                    TextFieldInput(
                        textEditingController: controller.serviceCost,
                        hintText: LocalKeys.kCost.tr,
                        textInputType: TextInputType.text
                    ),

                  ],
                ),
                ElevatedButton(
                    onPressed: ()async{await controller.addRoomServiceToBuffer();},
                    child: SmallText(text: LocalKeys.kStore.tr ,color: ColorsManager.white)
                ),
                thinDivider(),

                // Obx(() => controller.roomServiceBufferCount.value > 0 ? const DisplayRoomServiceBuffer():
                // SizedBox( height: const Size.fromHeight(1).height,),) ,

                const DisplayRoomServiceBuffer(),

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
                          onPressed: (){
                            controller.clearFormInputs();
                            controller.receivedRoomServiceBuffer.value.clear();
                            Navigator.of(Get.overlayContext!).pop();
                          }, child: SmallText(text: LocalKeys.kCancel.tr,color: ColorsManager.white,)
                      ),
                      ElevatedButton(
                          onPressed: (){
                            controller.storeRoomServices();
                            Navigator.of(context).pop();
                          },

                          child: SmallText(text: LocalKeys.kReceive.tr ,color: ColorsManager.white)
                      ),
                    ],
                  ),
                ),

      ],
    ));
  }
}

class DisplayRoomServiceBuffer extends GetView<RoomServiceFormController>{

  const DisplayRoomServiceBuffer({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return GetBuilder<RoomServiceFormController>(
      init: RoomServiceFormController(),
        builder: (controller)=> SizedBox(
            height: const Size.fromHeight(AppSize.size150*1.5).height,
            child: Obx(() => controller.roomServiceBufferCount.value > 0 ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
              ),
              children: List<Widget>.generate(controller.roomServiceBufferCount.value, (index) {
                return Builder(builder: (BuildContext context){
                  return Obx(() => MyOutlinedButton(
                    height: AppSize.size64*2,
                    text: controller.receivedRoomServiceBuffer.value[index].transactionNotes.toString(),
                    onClick: (){},backgroundColor: ColorsManager.grey2,textColor: ColorsManager.darkGrey,
                    borderColor: ColorsManager.primary.withOpacity(0.5),
                  ));
                });
              }),
            ): const Center(child: BigText(text: '',),))
        )
    );
  }
}