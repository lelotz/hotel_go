import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/package_form_controller.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/resourses/size_manager.dart';
import '../../../../../core/utils/dim_logic.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/buttons/decorated_text_button.dart';
import '../../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../../widgets/inputs/text_field_input.dart';
import '../../../../../widgets/mydividers.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../tables/display_stored_items.dart';
import 'dialog_forms.dart';

class StorePackageForm extends GetView<PackageFormController> {

  const StorePackageForm({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Dialog Form Header
            /// Includes Room Number, Status, Guest Name, and Form Title
            dialogFormHeader(LocalKeys.kStorePackageForm.tr),


            /// Receive and Return Buttons
            Obx(()=>Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DecoratedTextButton(
                      buttonLabel: '${LocalKeys.kReceive.tr} ${LocalKeys.kItem.tr}',
                      onPressed: controller.receivePackage,
                      backgroundColor: controller.receivingPackage.value ? Colors.blue : Colors.white24,
                    ),
                    DecoratedTextButton(
                      buttonLabel: '${LocalKeys.kReturn.tr} ${LocalKeys.kItem.tr}',
                      onPressed: controller.returnPackage,
                      backgroundColor: controller.returningPackage.value ? Colors.blue:Colors.white24 ,
                    ),
                  ],
                ),
                SizedBox(height: const Size.fromHeight(20).height,),
                BigText(text: controller.receivingPackage.value ? "${LocalKeys.kStore.tr} ${LocalKeys.kItems.tr}" : "${LocalKeys.kItems.tr} ${LocalKeys.kStored.tr} "),
                thinDivider()
              ],
            ),),

            /// Input Stored Items
            Obx(()=>controller.receivingPackage.value ? const InputPackagesToStore(): SizedBox(height: const Size.fromHeight(20).height,),),

            /// Display Stored Items
            Obx(()=> controller.receivingPackage.value ? controller.receivedPackagesBufferCount > 0 ? const DisplayNewPackageBuffer():SizedBox() : const DisplayStoredItems(),),

            /// Key Action and Stored Item Button
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
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey,),
                            onPressed: (){
                              //Navigator.pop(formDropdownKey.currentContext!);
                              Navigator.of(context).pop();
                              controller.receivedPackagesBuffer.value.clear();
                              controller.updateUI();
                            }, child: SmallText(text: LocalKeys.kCancel.tr,color: ColorsManager.white,)
                        ),

                        /// Store Added Packages to Database
                        Obx(()=>ElevatedButton(
                            onPressed: (){
                              controller.receivingPackage.value ? controller.storeClientPackage():
                              controller.returnClientPackage();

                            },
                            child: SmallText(text: controller.receivingPackage.value ?
                            '${LocalKeys.kReceive.tr} ${LocalKeys.kItem.tr}' :
                            '${LocalKeys.kReturn.tr} ${LocalKeys.kItems.tr}',
                              color: ColorsManager.white,
                            ))
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

class InputPackagesToStore extends GetView<PackageFormController> {
  const InputPackagesToStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  textEditingController: controller.packageDescriptionCtrl,
                  hintText: LocalKeys.kDescription.tr,
                  textInputType: TextInputType.text,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  textEditingController: controller.packageQuantityCtrl,
                  hintText: LocalKeys.kUnit.tr,
                  textInputType: TextInputType.text,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  textEditingController: controller.packageValueCtrl,
                  hintText: LocalKeys.kTotalCost.tr,
                  textInputType: TextInputType.text,
                ),
              ),
            ),

          ],
        ),
        /// Save New Item Button
        ElevatedButton(
            onPressed:controller.bufferNewStoredPackage,
            child: SmallText(text: LocalKeys.kStore.tr,color: Colors.white,)
        ),
        thinDivider(),
      ],
    ));
  }
}

class DisplayNewPackageBuffer extends GetView<PackageFormController>{

  const DisplayNewPackageBuffer({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>
        Obx(() =>  SizedBox(
          height: const Size.fromHeight(128).height,
          child: controller.receivedPackagesBuffer.value.isNotEmpty ? GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 5,
            ),
            children: List<Widget>.generate(controller.receivedPackagesBufferCount.value, (index) {
              return Builder(builder: (BuildContext context){
                return Obx(() => MyOutlinedButton(
                  text: "${controller.receivedPackagesBuffer.value[index].unit}:${controller.receivedPackagesBuffer.value[index].description}",
                  onClick: (){},backgroundColor: ColorsManager.grey2,textColor: ColorsManager.darkGrey,
                  borderColor: ColorsManager.primary.withOpacity(0.5),

                ));
              });
            }),
          ): const Center(child: BigText(text: '',),),
        )))
    ;
  }
}