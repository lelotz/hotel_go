import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/check_in_screen/view/check_in_form_view.dart';
import 'package:hotel_pms/app/modules/reports/view/handover_report_tables/petty_cash_table.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/forms/form_header.dart';
import '../../../../widgets/icons/app_icon.dart';
import '../../../../widgets/text/small_text.dart';
import '../controller/handover_form_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'handover_report_tables/conference_usage_table.dart';
import 'handover_report_tables/hotel_issues_table.dart';
import 'handover_report_tables/laundry_usage_table.dart';
import 'handover_report_tables/room_service_table.dart';
import 'handover_report_tables/rooms_used_table.dart';

class HandoverReport extends GetView<ReportGeneratorController> {
  HandoverReport({Key? key, required this.reportConfigs}) : super(key: key);

  final Map<String, dynamic> reportConfigs;

  final GlobalKey<SfDataGridState> hotelIssuesTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> roomServiceTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> laundryTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> conferenceTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> roomsTableKey = GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> pettyCashTableKey = GlobalKey<SfDataGridState>();



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        init: ReportGeneratorController(reportConfigs: reportConfigs),
        builder: (controller) => Scaffold(
              appBar: buildGlobalAppBar(context, appBarTitle: "Handover Form",onBackButton: (){
                Get.back();
                Get.delete<ReportGeneratorController>();
              }),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 200),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // EmptyIllustration(),
                      Row(
                        children: [
                          const BigText(text: "Export Report"),
                          Obx(() => controller.isExporting.value
                              ? loadingAnimation()
                              : IconButton(
                                  onPressed: () async {
                                    await controller.submitReport({
                                      'Rooms': roomsTableKey,
                                      'Conference': conferenceTableKey,
                                      'Room Service': roomServiceTableKey,
                                      'Laundry': laundryTableKey,
                                      'Hotel Issues': hotelIssuesTableKey,
                                      'Petty Cash' : pettyCashTableKey,
                                    });
                                  },
                                  icon: const Icon(Icons.save_alt_outlined)))
                        ],
                      ),
                      const ReportConfigurationForm(),
                      RoomsUsedSection(roomsTableKey: roomsTableKey,),
                      ConferenceUsageSection(conferenceTableKey: conferenceTableKey,),
                      LaundryUsageSection(laundryTableKey: laundryTableKey,),
                      RoomServiceTransactionsSection(roomServiceTableKey: roomServiceTableKey,),
                      PettyCashUsageSection(pettyCashTableKey: pettyCashTableKey),
                      HotelIssuesSection(hotelIssuesTableKey: hotelIssuesTableKey,),
                      const HandoverDetailsForm(),
                      Card(
                        child: InkWell(
                            hoverColor: ColorsManager.primaryAccent,
                            onTap: () async {
                              await controller.submitReport({
                                'Rooms': roomsTableKey,
                                'Conference': conferenceTableKey,
                                'Room Service': roomServiceTableKey,
                                'Laundry': laundryTableKey,
                                'Hotel Issues': hotelIssuesTableKey,
                                'Petty Cash' : pettyCashTableKey,
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Obx(
                                () => controller.isExporting.value
                                    ? loadingAnimation(
                                        actionStatement: 'Exporting')
                                    : const BigText(
                                        text: 'Submit Report',
                                      ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

class ReportConfigurationForm extends GetView<ReportGeneratorController> {
  const ReportConfigurationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        init: ReportGeneratorController(reportConfigs: Get.find<ReportGeneratorController>().reportConfigs),
        builder: (controller) => Card(
              child: Column(
                children: [
                  buildFormHeader("Configure Report",
                      enableCancelButton: false),
                  SizedBox(
                    height: const Size.fromHeight(20).height,
                  ),

                  /// Session Report CheckBox
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SmallText(text: 'Report for current session only'),
                            SizedBox(width: const Size.fromWidth(15).width,),
                            Obx(() => Checkbox(
                                  value: controller.isHandoverReport.value,
                                  onChanged: controller.handleReportConfigurationOptions),
                            )
                          ],
                        ),
                        Card(
                          child: InkWell(
                            onTap: ()async{
                              await controller.initData();
                              controller.update();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: BigText(text: 'Create Report',),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: const Size.fromHeight(20).height,),
                  Obx(() => controller.isHandoverReport.value==false ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Row(children: [

                          /// Start Date
                          Container(
                            width: const Size.fromWidth(200).width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                Border.all(color: Colors.black, width: 2.0),
                                color: ColorsManager.flutterGrey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                      () => Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child:
                                    controller.reportStartDate.value == null
                                        ? const SmallText(
                                        text: "Select Start Date")
                                        : BigText(
                                        text: extractDate(controller
                                            .reportStartDate.value)),
                                  ),
                                ),
                                const SmallText(text: 'Start Date'),
                                InkWell(
                                    onTap: () {
                                     showDatePicker(
                                          context: context,
                                          initialDate: controller.reportStartDate.value,
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime(2024))
                                          .then((selectedDate) async{
                                        if (selectedDate != null) {
                                          controller.reportStartDate.value =
                                              selectedDate;
                                          controller.update();
                                        }
                                      });
                                    },
                                    child: const AppIcon(
                                      icon: Icons.calendar_month,
                                      useBackground: true,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: const Size.fromWidth(15).width,
                          ),
                          /// End Date
                          Container(
                            width: const Size.fromWidth(200).width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                Border.all(color: Colors.black, width: 2.0),
                                color: ColorsManager.flutterGrey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: controller.reportEndDate.value == null
                                      ? const SmallText(text: "Select End Date")
                                      : BigText(
                                      text: extractDate(
                                          controller.reportEndDate.value)),
                                ),
                                const SmallText(text: 'End Date'),
                                InkWell(
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: controller
                                              .reportEndDate.value,
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime(2024))
                                          .then((selectedDate) {
                                        if (selectedDate != null) {
                                          controller.reportEndDate.value =
                                              selectedDate;
                                          controller.update();
                                        }
                                      });
                                    },
                                    child: const AppIcon(
                                      icon: Icons.calendar_month,
                                      useBackground: true,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: const Size.fromWidth(15).width,
                          )
                        ]),
                        SizedBox(
                          height: const Size.fromHeight(20).height,
                        ),
                      ],
                    ),
                  ): const SizedBox(),)
                ],
              ),
            ));
  }
}

class HandoverDetailsForm extends GetView<ReportGeneratorController> {
  const HandoverDetailsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        init: ReportGeneratorController(),
        builder: (controller) => Card(
              child: Column(
                children: [
                  buildFormHeader("Collected Payments",
                      enableCancelButton: false),
                  SizedBox(
                    height: const Size.fromHeight(20).height,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextFieldInput(
                              textEditingController: controller.roomPaymentsCtr,
                              hintText: 'Room',
                            )),
                            SizedBox(
                              width: const Size.fromWidth(20).width,
                            ),
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.roomDebtPaymentsCtr,
                              hintText: 'Room Debts',
                            )),
                            SizedBox(
                              width: const Size.fromWidth(20).width,
                            ),
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.conferencePaymentsCtr,
                              hintText: 'Conference',
                            )),
                            //SizedBox(width: const Size.fromWidth(20).width,),
                          ],
                        ),
                        SizedBox(
                          height: const Size.fromHeight(20).height,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.roomServicePaymentsCtr,
                              hintText: 'Room Service',
                            )),
                            SizedBox(
                              width: const Size.fromWidth(20).width,
                            ),
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.laundryPaymentsCtr,
                              hintText: 'Laundry',
                            )),
                            SizedBox(
                              width: const Size.fromWidth(20).width,
                            ),
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.totalDailyPaymentsCtr,
                              hintText: 'Total',
                            )),
                            //SizedBox(width: const Size.fromWidth(20).width,),
                          ],
                        ),
                        SizedBox(
                          height: const Size.fromHeight(20).height,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFieldInput(
                              textEditingController:
                                  controller.conferenceAdvancePaymentsCtr,
                              hintText: 'Conference Advance',
                            )),
                            SizedBox(
                              width: const Size.fromWidth(20).width,
                            ),

                            //SizedBox(width: const Size.fromWidth(20).width,),
                          ],
                        ),
                        SizedBox(
                          height: const Size.fromHeight(20).height,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class RoomUsedForm extends GetView<ReportGeneratorController> {
  const RoomUsedForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        init: ReportGeneratorController(),
        builder: (controller) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextFieldInput(
                        textEditingController: controller.roomNumberController,
                        hintText: 'Room Number',
                      )),
                    ],
                  ),
                  //SizedBox(height: const Size.fromHeight(100).height,),
                  MyOutlinedButton(
                      text: 'Submit',
                      onClick: () {
                        Navigator.of(Get.overlayContext!).pop();
                        Get.to(() => CheckInView(
                              roomNumber: controller.roomNumberController.text,
                              isReport: true,
                            ));
                      })
                ],
              ),
            ));
  }
}

Widget reportEntryHeader(
    {required Function onRefreshEntries,
    required String title,
    required Function onAddEntry,
    required Function onConfirmEntry,
    required Function onSave}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyOutlinedButton(
            text: 'Add Entry',
            onClick: onAddEntry,
            borderColor: ColorsManager.primary,
          ),
          SizedBox(
            width: const Size.fromWidth(20).width,
          ),
          MyOutlinedButton(
            text: 'Confirm Entries',
            onClick: onConfirmEntry,
            backgroundColor: ColorsManager.white,
            textColor: ColorsManager.darkGrey,
            borderColor: ColorsManager.darkGrey,
            currentTextColor: ColorsManager.darkGrey,
          ),
          SizedBox(
            width: const Size.fromWidth(20).width,
          ),

          IconButton(
              onPressed: () async{
                await onRefreshEntries();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                await onSave();
              },
              icon: const Icon(Icons.save_alt_outlined)),
          //MyOutlinedButton(text: 'Update', onClick: onRefreshEntries,borderColor:ColorsManager.primary,),
        ],
      ),
    ],
  );
}
