import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/title_subtitle.dart';
import 'package:get/get.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/mydividers.dart';
import '../../../../widgets/text/small_text.dart';
import '../../guest_dashboard/views/guest_dashboard_view.dart';
import '../controller/check_in_form_controller.dart';

class CheckInView extends GetView<CheckInFormController> {
  String? roomNumber;
  bool isReport;
  CheckInView({Key? key,this.roomNumber='',this.isReport=false}) : super(key: key);

  double inputWidth = 250;
  double inputPairWidth = 500;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            /// Form
            Padding(
              padding:  EdgeInsets.only(left: const Size.fromWidth(40).width,right: const Size.fromWidth(40).width),
              child: Column(
                children: [
                  SizedBox(height: const Size.fromHeight(30).height,),
                  BigText(text: "${LocalKeys.kNewGuest.tr}: ${controller.selectedRoomData.value.roomNumber}"),
                  thinDivider(),
                  BigText(text: LocalKeys.kCheckInDetails.tr),
                  thinDivider(),
                  SizedBox(height: const Size.fromHeight(100).height,),
                  /// Nights and FullName
                  SizedBox(
                    width: inputPairWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.nightsCtrl,
                                onChanged: controller.stayCost,
                                hintText: LocalKeys.kNights.tr,
                                textInputType: TextInputType.number
                            ),
                          ),
                        ),
                        SizedBox(width: const Size.fromWidth(35).width,),
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.fullNameCtrl,
                                hintText: LocalKeys.kFullName.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: const Size.fromHeight(15).height,),

                  /// Check In Date Selector and Guest's location of origin
                  SizedBox(
                    width: inputPairWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Check-In Date
                        Expanded(
                          child: Container(
                            width: const Size.fromWidth(200).width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black,width: 2.0),
                                color: ColorsManager.flutterGrey
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: controller.checkInDate.value == null ?
                                  const SmallText(text: "Select Check-In Date") : BigText(text: extractDate(controller.checkInDate.value)),
                                ),
                                SmallText(text: LocalKeys.kCheckIn.tr),
                                InkWell(
                                    onTap: (){
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime(2024)
                                      ).then((selectedDate) {
                                        if(selectedDate!=null) controller.checkInDate.value = selectedDate;
                                      });
                                    },
                                    child: const AppIcon(icon: Icons.calendar_month,useBackground: true,)
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: const Size.fromWidth(35).width,),

                        /// Guest coming from
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.comingFromCtrl,
                                hintText: LocalKeys.kComingFrom.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: const Size.fromHeight(15).height,),

                  /// Check Out Date and Guest's destination
                  SizedBox(
                    width: inputPairWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Obx(() => CheckOutDateBox(selectedDate: controller.checkInDate.value,liveNights: controller.nightsCtrl,)),
                        ),
                        SizedBox(width: const Size.fromWidth(35).width,),
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.goingToCtrl,
                                hintText: LocalKeys.kGoingTo.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: const Size.fromHeight(15).height,),

                  /// Number of Adults Guests and ID type
                  SizedBox(
                    width: inputPairWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.adultsCtrl,
                                hintText: LocalKeys.kAdults.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                        SizedBox(width: const Size.fromWidth(35).width,),
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.idTypeCtrl,
                                hintText: LocalKeys.kIdType.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: const Size.fromHeight(15).height,),

                  /// Number of Child Guests and ID Number
                  SizedBox(
                    width: inputPairWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.childrenCtrl,
                                hintText: LocalKeys.kChildren.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                        SizedBox(width: const Size.fromWidth(35).width,),
                        Expanded(
                          child: SizedBox(
                            width: inputWidth,
                            child: TextFieldInput(
                                textEditingController: controller.idNumberCtrl,
                                hintText: LocalKeys.kIdNumber.tr,
                                textInputType: TextInputType.text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            Padding(
             padding:  EdgeInsets.only(left: const Size.fromWidth(40).width,right: const Size.fromWidth(40).width),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFieldInput(
                          textEditingController: controller.paidTodayCtrl,
                          onChanged: controller.calculateOutstandingBalance,
                          hintText: LocalKeys.kPaidToday.tr,
                          textInputType: TextInputType.number
                      ),
                    ),
                    SizedBox(height: const Size.fromHeight(75).height),
                    Card(
                      child: InkWell(
                        onTap: ()async{
                          await controller.checkInGuest();
                          isReport ? Get.back() : Get.to(()=> const GuestDashboardView());
                          Get.delete<CheckInFormController>();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: BigText(text: LocalKeys.kCheckIn.tr,),
                        ),
                      ),
                    ),
                  ],
                ),
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



