import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/homepage_screen/views/homepage_view.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../controller/clear_controllers.dart';
import '../widgets/app_forms/dialog_forms.dart';
import '../widgets/app_forms/forms_dropdown_menu.dart';
import '../widgets/cards/room_and_guest_card.dart';
import '../../../../widgets/text/title_subtitle.dart';
import 'package:get/get.dart';
import '../controller/guest_dashboard_controller.dart';
import '../widgets/tables/user_activity_table.dart';

class GuestDashboardView extends GetView<GuestDashboardController> {

  const GuestDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GetBuilder<GuestDashboardController>(
      init: GuestDashboardController(),
      builder: (controller)=>
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: ()async{
                Get.to(()=>HomePageView());
                //Get.reset();
                await deleteRoomControllers();
              },
              child: const AppIcon(
                icon: Icons.arrow_back,
              ),
            ),
            title: buildAppBarTitle("Guest Dashboard"),
          ),

          body: Obx(()=> controller.isLoadingData.value ? loadingAnimation() :SingleChildScrollView(
           child:  Padding(
             padding: const EdgeInsets.only(left: AppPadding.padding20*2,right: AppPadding.padding20*2,top: AppPadding.padding20),
             child: Column(
               children: [

                 /// Forms Row
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children:  [
                     Center(
                       child: BigText(text: LocalKeys.kDetails.tr, size: 25,),
                     ),
                     Row(
                       children: [
                         ElevatedButton(
                             onPressed: (){controller.checkOutGuest();},
                             child: const SmallText(text: LocalKeys.kCheckout,color: ColorsManager.grey2,)),
                         SizedBox(width: const Size.fromWidth(AppSize.size12).width,),
                         ElevatedButton(
                             onPressed: (){controller.receiveRoomKey();},
                             child: SmallText(text: "${LocalKeys.kReceive.tr} ${LocalKeys.kKey.tr}",color: ColorsManager.grey2,)),
                         SizedBox(width: const Size.fromWidth(AppSize.size12).width,),
                         ElevatedButton(
                             onPressed: (){controller.returnRoomKey();},
                             child: SmallText(text: "${LocalKeys.kReturn.tr} ${LocalKeys.kKey.tr}",color: ColorsManager.grey2)),
                         SizedBox(width: const Size.fromWidth(AppSize.size12).width,),
                         BigText(text: LocalKeys.kForms.tr),
                         SizedBox(width: const Size.fromWidth(AppSize.size12).width,),
                         GuestActionsDropdown(
                           menuItems: AppConstants.formNames.map((e) => e.tr).toList(),
                           callback: actionsDialogForms,
                           initialItem: AppConstants.formNames[0],
                         ),
                       ],
                     ),
                   ],
                 ),
                 thinDivider(),

                 Row(
                   children: [
                     /// Guest Info Card
                     Expanded(
                         flex: 2,
                         child: Card(
                           //height: getHeight(context, 430),
                           // decoration: BoxDecoration(
                           //     borderRadius: BorderRadius.circular(AppBorderRadius.radius16),
                           //     border: Border.all(color: ColorsManager.darkGrey)
                           // ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,

                             children: [
                               /// Print Room Details
                               const AppIcon(icon: Icons.print,useBackground: true,),

                               /// Room Number & Status
                               const RoomAndGuestCard(isRow:false,roomCardWidth: 75,),

                               /// Guest Details
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(top: 30,right: AppPadding.padding20,left: AppPadding.padding20),
                                     child: Center(
                                       child: Container(
                                         //width: getWidth(context, 300),
                                         decoration: const BoxDecoration(
                                             boxShadow:  [
                                               BoxShadow(
                                                   color: Color(0xFFe8e8e8),
                                                   blurRadius: 5,
                                                   offset: Offset(0,2)
                                               ),
                                               BoxShadow(color: Colors.white, offset: Offset(-5,0)),
                                               BoxShadow(color: Colors.white, offset: Offset(5,0))
                                             ],
                                             borderRadius: BorderRadius.all(Radius.circular(15))
                                         ),
                                         child: Padding(
                                           padding: const EdgeInsets.all(AppPadding.padding8),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               //const AppIcon(icon: Icons.calendar_month,iconSize: 20,useBackground: true,),
                                               LabeledText(
                                                 title: LocalKeys.kCheckIn.tr,
                                                 subtitle: controller.checkInDate.value,
                                                 subtitleColor: ColorsManager.darkGrey,
                                                 titleSize: AppSize.size16,subtitleSize: AppSize.size20,
                                               ),
                                               SizedBox(width: const Size.fromWidth(10).width,),
                                               const SmallText(text: "|",size: 40,),
                                               SizedBox(width: const Size.fromWidth(10).width,),
                                               LabeledText(
                                                 title: LocalKeys.kCheckout, subtitle: controller.checkOutDate.value,subtitleColor: ColorsManager.darkGrey,
                                                 titleSize: AppSize.size16,subtitleSize: AppSize.size20,
                                               ),

                                             ],
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),


                               /// Cost Summary
                               Padding(
                                 padding: const EdgeInsets.only(top: AppPadding.padding40*2,right: AppPadding.padding8,left: AppPadding.padding8,bottom: AppPadding.padding8),
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Colors.black87,
                                       border: Border.all(color: ColorsManager.darkGrey),
                                       borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.radius16))
                                   ),

                                   child: Center(
                                     child: Column(
                                       children: [
                                        Obx(()=> Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            LabeledText(title: LocalKeys.kTotalCost.tr, isNumber: true,subtitle: controller.paymentDataController.roomTransaction.value.grandTotal.toString(),subtitleColor: Colors.white,titleSize: AppSize.size16,subtitleSize: AppSize.size20,),
                                            SizedBox(width:const Size.fromWidth(20).width,),
                                            LabeledText(title: LocalKeys.kPaid.tr,isNumber: true, subtitle: controller.paymentDataController.roomTransaction.value.amountPaid.toString(),titleSize: AppSize.size16,subtitleSize: AppSize.size20,),
                                            SizedBox(width: const Size.fromWidth(20).width,),
                                            LabeledText(title: LocalKeys.kBalance.tr,isNumber: true,subtitle: controller.paymentDataController.roomTransaction.value.outstandingBalance.toString(),titleSize: AppSize.size16,
                                              subtitleSize: AppSize.size20,
                                              subtitleColor: controller.paymentDataController.roomTransaction.value.outstandingBalance! > 0 ? ColorsManager.grey2 :ColorsManager.darkGrey,
                                            ),

                                          ],
                                        )),
                                         SizedBox(height: const Size.fromHeight(20).height,),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         )
                     ),

                     /// Activity Table
                     Expanded(
                         flex: 6,
                         child: Column(
                           children:  [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Obx(() => BigText(text: "${LocalKeys.kGuestActivity.tr} : ${controller.userActivity.value.length}")),
                                 SizedBox(width: const Size.fromWidth(8).width,),
                                 IconButton(
                                     onPressed: controller.onInit, icon: const Icon(Icons.refresh_rounded))
                               ],
                             ),
                             SizedBox(
                                 height: const Size.fromHeight(500).height,
                                 child: const UserActivityTableView()
                             ),
                           ],
                         )
                     ),

                   ],
                 )

               ],
             ),
           ),
         )

      ),
    ));
  }
}
