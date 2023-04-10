import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/values/app_constants.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/dropdown_menu/custom_dropdown_menu.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/payment_form_controller.dart';





class CollectPaymentForm extends GetView<PaymentController> {
  CollectPaymentForm({Key? key}) : super(key: key);
  final paymentForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      init: PaymentController(),
        builder: (controller)=>Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildFormHeader(LocalKeys.kCollectPaymentForm.tr),
                SizedBox(height: const Size.fromHeight(20).height,),
                Obx(() => Padding(
               padding: const EdgeInsets.only(left: AppSize.size44),
               child: Table(

               children:  [

                 TableRow(
                     children: [
                       SmallText(text: LocalKeys.kRoom.tr,),
                       SmallText(text: LocalKeys.kRoomService.tr,),
                       SmallText(text: LocalKeys.kLaundry.tr,),
                       SmallText(text: LocalKeys.kTotal.tr,)
                     ]
                 ),
                 TableRow(
                     children:[
                       BigText(text: controller.roomCost.toString(),),
                       BigText(text: controller.roomServiceCost.value.toString(),),
                       BigText(text: controller.laundryCost.value.toString(),),
                       BigText(text: controller.grandTotal.value.toString(),)
                     ]
                 ),
               ],
       ),
             ),),
                SizedBox(height: const Size.fromHeight(50).height,),
                Obx(() => Padding(
                  padding: const EdgeInsets.only(left: AppSize.size44),
                  child: Table(

                    children:  [

                      TableRow(
                          children: [
                            SmallText(text: LocalKeys.kBalance.tr,),
                            SmallText(text: LocalKeys.kBalance.tr,),
                            SmallText(text: LocalKeys.kBalance.tr,),
                            SmallText(text: LocalKeys.kBalance.tr,)
                          ]
                      ),
                      TableRow(
                          children:[
                            BigText(text: controller.roomBalance.value.toString(),),
                            BigText(text: controller.roomServiceBalance.value.toString(),),
                            Obx(() => BigText(text: controller.laundryBalance.value.toString(),),),
                            BigText(text: controller.grandTotalOutstandingBalance.value.toString(),)
                          ]
                      ),
                    ],
                  ),
                ),),
                SizedBox(height: const Size.fromHeight(20).height,),


                /// Collect Payment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: Obx(() => BigText(text: controller.collectedPaymentInput.value,))
                        ),
                      ),
                    ),

                    SizedBox(width: const Size.fromWidth(10).width,),

                    Expanded(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(text: LocalKeys.kBillType.tr),
                          SizedBox(width: const Size.fromWidth(10).width,),
                          GeneralDropdownMenu(
                              menuItems: AppConstants.serviceTypes.values.toList(),
                              callback: controller.selectBill,
                                initialItem: LocalKeys.kRoom.tr

                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: const Size.fromWidth(10).width,),
                    Expanded(
                      child: Obx(() => GeneralDropdownMenu(
                        menuItems: PaymentMethods.toList(),
                        callback: controller.setPayMethod,
                        initialItem: "Pay Method",
                        borderColor:
                        controller.payMethodStatus.value == ''
                            ? ColorsManager.darkGrey
                            : ColorsManager.error,

                      )),
                    ),

                  ],
                ),
                SizedBox(height: const Size.fromHeight(20).height,),

            ///
         ],
        ),

            /// Save and Cancel Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Get.delete<PaymentController>();
                    },
                    child: SmallText(text: LocalKeys.kCancel.tr,color: ColorsManager.black,),
                  ),
                  Column(
                    children: [
                      Obx(() => controller.payMethodStatus.value == '' ? SizedBox():
                      Card(
                        elevation: 0.9,
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SmallText(text: controller.payMethodStatus.value.tr,color: ColorsManager.error,),
                      ))),
                      Card(
                        color: ColorsManager.primaryAccent,
                        child: InkWell(
                          onTap: ()async {
                            if (controller.validateInputs()) {
                              await controller.payBill();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                children: [

                                  SmallText(text: LocalKeys.kCollectPayment.tr,color: ColorsManager.white,),
                                ]
                            ),
                          )
                        ),
                      ),
                    ],
                  )

                ],
              ),
            )

          ],
        ));
  }
}