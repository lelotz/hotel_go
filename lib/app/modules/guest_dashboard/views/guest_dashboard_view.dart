import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/widgets/cards/house_keeping_status.dart';
import 'package:hotel_pms/app/modules/homepage_screen/views/homepage_view.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../controller/clear_controllers.dart';
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
      init: GuestDashboardController(isTest: false),
      builder: (controller)=>
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: ()async{
                await controller.homepageController.loadRoomData();
                Get.to(()=>HomePageView());
                await deleteRoomControllers();
              },
              child: const AppIcon(
                icon: Icons.arrow_back,
              ),
            ),
            title: buildAppBarTitle("Guest Dashboard"),
          ),

          body: Obx(()=> controller.isLoadingData.value ? loadingAnimation(size: 50) : SingleChildScrollView(
           child:  Padding(
             padding: const EdgeInsets.only(left: AppPadding.padding20*2,right: AppPadding.padding20*2,top: AppPadding.padding20),
             child: Column(
               children: [

                 /// Forms Row
                 Obx(() => controller.isCheckedOut.value ?  SizedBox() : Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children:  [
                     Center(
                       child: BigText(text: LocalKeys.kDetails.tr, size: 25,),
                     ),
                     Row(
                       children: [
                         ElevatedButton(
                             onPressed: ()async{
                               showDatePicker(
                                   context: context,
                                   initialDate:
                                   DateTime.now(),
                                   firstDate: DateTime.parse(controller.paymentDataController.roomTransaction.value.checkInDate!),
                                   lastDate: DateTime(2024)).then((value) async{
                                     await controller.extendGuestStay(value!);
                               });
                             },
                             child: const SmallText(text: LocalKeys.kExtendStay,color: ColorsManager.grey2,)),
                         SizedBox(width: const Size.fromWidth(AppSize.size12).width,),
                         ElevatedButton(
                             onPressed: ()async{ await controller.checkOutGuest();},
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
                         GeneralDropdownMenu(
                             menuItems: AppConstants.formNames,
                             callback: controller.openDashboardForm,
                             initialItem: AppConstants.formNames[0]
                         ),

                       ],
                     ),
                   ],
                 )),
                 thinDivider(),

                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
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
                                           child: Obx(() => Column(
                                             children: [
                                               Row(
                                                 children: [

                                                   Icon(Icons.nights_stay_outlined),
                                                   SizedBox(width: Size.fromWidth(10).width,),
                                                   SmallText(text: 'Siku : ${controller.paymentDataController.roomTransaction.value.nights}'),

                                                 ],
                                               ),
                                               Row(
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
                                             ],
                                           ),)
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
                                       color: Colors.black87.withOpacity(0.8),
                                       border: Border.all(color: ColorsManager.darkGrey),
                                       borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.radius16))
                                   ),

                                   child: Center(
                                     child: Column(
                                       children: [
                                        Obx(()=> Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            LabeledText(title: LocalKeys.kTotalCost.tr, isNumber: true,subtitle: controller.paymentDataController.roomTransaction.value.grandTotal.toString(),subtitleColor: Colors.white,titleColor: ColorsManager.white.withOpacity(.8),titleSize: AppSize.size16,subtitleSize: AppSize.size20,),
                                            SizedBox(width:const Size.fromWidth(20).width,),
                                            LabeledText(title: LocalKeys.kPaid.tr,isNumber: true,
                                                subtitle: controller.paymentDataController.roomTransaction.value.amountPaid.toString(),
                                                subtitleColor: ColorsManager.success,
                                                titleSize: AppSize.size16,subtitleSize: AppSize.size20,
                                                titleColor: ColorsManager.white.withOpacity(.8)),
                                            SizedBox(width: const Size.fromWidth(20).width,),
                                            LabeledText(title: LocalKeys.kBalance.tr,isNumber: true,
                                              subtitle: controller.paymentDataController.roomTransaction.value.outstandingBalance.toString(),titleSize: AppSize.size16,titleColor: ColorsManager.white.withOpacity(.8),
                                              subtitleSize: AppSize.size20,
                                              subtitleColor: controller.paymentDataController.roomTransaction.value.outstandingBalance! > 0 ? ColorsManager.error :ColorsManager.darkGrey,
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

                     /// Activity Table or Housekeeping form
                     Expanded(
                         flex: 6,
                         child: Obx(() => controller.isCheckedOut.value ? HouseKeepingRoomStatus() : Column(
                           children:  [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Obx(() => BigText(text: "${LocalKeys.kGuestActivity.tr} : ${controller.userActivity.value.length}")),
                                 SizedBox(width: const Size.fromWidth(8).width,),
                                 controller.fetchingUserActivity.value ? loadingAnimation(actionStatement: '',size: 20) : IconButton(
                                     onPressed: ()async{
                                       await controller.getUserActivity();

                                     }, icon: const Icon(Icons.refresh_rounded))
                               ],
                             ),
                             SizedBox(
                                 height: const Size.fromHeight(700).height,
                                 child: const UserActivityTableView()
                             ),
                           ],
                         ))
                     )

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
