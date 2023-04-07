import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';
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
import '../../controller/package_form_controller.dart';
import '../tables/display_stored_items.dart';
import 'dialog_forms.dart';

class StorePackageForm extends GetView<PackageFormController> {

  StorePackageForm({Key? key,}) : super(key: key);
  final packageStorageFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Dialog Form Header
            /// Includes Room Number, Status, Guest Name, and Form Title
            // dialogFormHeader(LocalKeys.kStorePackageForm.tr),
            buildFormHeader(LocalKeys.kStorePackageForm.tr),
            SizedBox(height: const Size.fromHeight(20).height,),


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
            Obx(()=>controller.receivingPackage.value ?InputPackagesToStore(formKey: packageStorageFormKey,): SizedBox(height: const Size.fromHeight(20).height,),),

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
                            onPressed: ()async{
                              if(packageStorageFormKey.currentState!.validate()){
                                controller.receivingPackage.value ? await controller.storeClientPackage():
                                await controller.returnClientPackage();
                              }
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
  const InputPackagesToStore({Key? key,required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>Form(
          key: formKey,
          child: Column(
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
                    validation: DataValidation.isAlphabeticOnly,
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
                    validation: DataValidation.isNotEmpty,
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
                    validation: DataValidation.isNumeric,
                  ),
                ),
              ),

            ],
          ),
          /// Save New Item Button
          ElevatedButton(
              onPressed:(){
                if(formKey.currentState!.validate()){
                  controller.bufferNewStoredPackage();
                }

              },
              child: SmallText(text: LocalKeys.kStore.tr,color: Colors.white,)
          ),
          thinDivider(),
      ],
    ),
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
          height: const Size.fromHeight(320).height,
          child: controller.receivedPackagesBuffer.value.isNotEmpty ? GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            children: List<Widget>.generate(controller.receivedPackagesBufferCount.value, (index) {
              return Builder(builder: (BuildContext context){
                return Obx(() => Card(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Item  : ${controller.receivedPackagesBuffer.value[index].description}",),
                        BigText(text: "Unit : ${controller.receivedPackagesBuffer.value[index].unit}",),
                        BigText(text: "Value : ${controller.receivedPackagesBuffer.value[index].activityValue}",)
                      ],
                    ),
                  ),
                ));
              });
            }),
          ): const Center(child: BigText(text: '',),),
        )))
    ;
  }
}