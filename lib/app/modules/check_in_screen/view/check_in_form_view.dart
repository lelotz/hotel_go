import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/buttons/decorated_text_button.dart';
import 'package:hotel_pms/widgets/buttons/my_outlined_button.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/title_subtitle.dart';
import 'package:get/get.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/mydividers.dart';
import '../../../../widgets/text/small_text.dart';
import '../../room_data_screen/views/room_details_view.dart';
import '../controller/check_in_form_controller.dart';

class CheckInView extends GetView<CheckInFormController> {
  String? roomNumber;
  bool isReport;
  CheckInView({Key? key,this.roomNumber='',this.isReport=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<CheckInFormController>(
      init: CheckInFormController(roomNumber: roomNumber!,isReport: isReport),
      builder: (controller) => Obx(() => Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: const AppIcon(
              icon: Icons.arrow_back,
            ),
          ),
          title: buildAppBarTitle(LocalKeys.kCheckInForm.tr),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: const Size.fromWidth(40).width,right: const Size.fromWidth(40).width),
              child: Column(
                children: [
                  SizedBox(height: const Size.fromHeight(40).height,),
                  BigText(text: "${LocalKeys.kNewGuest.tr}: ${controller.selectedRoomData.value.roomNumber}"),
                  thinDivider(),
                  BigText(text: LocalKeys.kCheckInDetails.tr),
                  thinDivider(),
                  /// Room, Staff Info & Form Inputs
                  Row(
                    children:   [

                      /// Room and Staff Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      border: Border.all(color: ColorsManager.darkGrey),
                                      borderRadius: const BorderRadius.all(Radius.circular(15))
                                  ),
                                  height:const Size.fromHeight(160).height,
                                  width: const Size.fromWidth(150).width,
                                  child: Center(child: BigText(text: controller.selectedRoomData.value.roomNumber.toString(),size: 60,)),
                                ),

                                controller.selectedRoomData.value.roomStatus == null ? loadingAnimation() : DecoratedTextButton(
                                    buttonLabel: controller.selectedRoomData.value.roomStatus!.description.toString().tr,
                                    backgroundColor: AppConstants.roomStatusColor[controller.selectedRoomData.value.roomStatus!.code]!,
                                    textColor: Colors.white,
                                    onPressed: (){}
                                ),
                              ],
                            ),

                            LabeledText(
                                title: Get.find<AuthController>().adminUser.value.position!,
                                subtitle: Get.find<AuthController>().adminUser.value.fullName!
                            )
                          ],
                        ),
                      ),

                      /// Form Inputs
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [

                            Center(
                              child: Row(

                                children: [

                                  /// STAY INFO
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      TextFieldInput(
                                          textEditingController: controller.nightsCtrl,
                                          onChanged: controller.stayCost,
                                          hintText: LocalKeys.kNights.tr,
                                          textInputType: TextInputType.number
                                      ),

                                      /// Check-In Date
                                      Padding(
                                        padding: const EdgeInsets.only(top: 25),
                                        child: Container(
                                          width: const Size.fromWidth(200).width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.black),
                                              color: Colors.white
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: controller.checkInDate.value == null ?
                                                const SmallText(text: "Select Check-In Date") : BigText(text: extractDate(controller.checkInDate.value)),
                                              ),
                                              InkWell(
                                                  onTap: (){
                                                    showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(2023),
                                                        lastDate: DateTime(2024)
                                                    ).then((selectedDate) {
                                                      controller.checkInDate.value = selectedDate!;
                                                    });
                                                  },
                                                  child: const AppIcon(icon: Icons.calendar_month,useBackground: true,)
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      //selectDate(context, checkOutDate, showDateDialog),
                                      Padding(
                                        padding: const EdgeInsets.only(top:20),
                                        child: Obx(() => CheckOutDateBox(selectedDate: controller.checkInDate.value,liveNights: controller.nightsCtrl,)),
                                      ),


                                      TextFieldInput(
                                          textEditingController: controller.adultsCtrl,
                                          hintText: LocalKeys.kAdults.tr,
                                          textInputType: TextInputType.text
                                      ),

                                      TextFieldInput(
                                          textEditingController: controller.childrenCtrl,
                                          hintText: LocalKeys.kChildren.tr,
                                          textInputType: TextInputType.text
                                      ),
                                      //const MyDatePicker()
                                    ],
                                  ),

                                  SizedBox(width: const Size.fromWidth(50).width,),
                                  /// GUEST INFO
                                  Column(
                                    children: [

                                      TextFieldInput(
                                          textEditingController: controller.fullNameCtrl,
                                          hintText: LocalKeys.kFullName.tr,
                                          textInputType: TextInputType.text
                                      ),
                                      TextFieldInput(
                                          textEditingController: controller.comingFromCtrl,
                                          hintText: LocalKeys.kComingFrom.tr,
                                          textInputType: TextInputType.text
                                      ),
                                      TextFieldInput(
                                          textEditingController: controller.goingToCtrl,
                                          hintText: LocalKeys.kGoingTo.tr,
                                          textInputType: TextInputType.text
                                      ),
                                      TextFieldInput(
                                          textEditingController: controller.idTypeCtrl,
                                          hintText: LocalKeys.kIdType.tr,
                                          textInputType: TextInputType.text
                                      ),
                                      TextFieldInput(
                                          textEditingController: controller.idNumberCtrl,
                                          hintText: LocalKeys.kIdNumber.tr,
                                          textInputType: TextInputType.text
                                      ),

                                    ],
                                  ),

                                  SizedBox(width: const Size.fromWidth(250).width,),

                                  /// PAYMENT INPUT & SAVE BUTTON
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextFieldInput(
                                          textEditingController: controller.paidTodayCtrl,
                                          onChanged: controller.calculateOutstandingBalance,
                                          hintText: LocalKeys.kPaidToday.tr,
                                          textInputType: TextInputType.number
                                      ),
                                      SizedBox(height: const Size.fromHeight(75).height),
                                      SizedBox(
                                          width: const Size.fromWidth(120).width,

                                          child: MyOutlinedButton(
                                            width: 50,
                                            height: 80,
                                            onClick: ()async{
                                              await controller.checkInGuest();
                                              isReport ? Get.back() : Get.to(()=> const RoomDetailsView());
                                              Get.delete<CheckInFormController>();

                                              },
                                            text:LocalKeys.kConfirmAndCheckIn.tr,
                                            textColor: ColorsManager.darkGrey,
                                            currentTextColor: ColorsManager.darkGrey,
                                            borderColor: Colors.black,
                                            backgroundColor: ColorsManager.flutterGrey,
                                          )
                                      )
                                    ],
                                  ),
                                  ///
                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),

            /// Cost Summary Bottom Row
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: const Size.fromWidth(20).width,),
                          Obx(() => LabeledText(title: LocalKeys.kTotalCost.tr,isNumber: true, subtitle: controller.roomCost.value.toString(),subtitleColor: Colors.white,),),
                          SizedBox(width: const Size.fromWidth(20).width,),
                          LabeledText(title: LocalKeys.kBalance.tr,isNumber: true, subtitle:controller.outstandingBalance.value.toString(),subtitleColor: Colors.white,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),)
    );
  }
}



