import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/check_in_screen/view/check_in_form_view.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/forms/form_header.dart';
import '../../book_service/view/book_service_form.dart';

import '../../widgtes/forms/hotel_issues_form.dart';
import '../controller/handover_form_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../table_sources/conference_usage_source.dart';
import '../table_sources/hotel_issues_source.dart';
import '../table_sources/laundry_transactions_source.dart';
import '../table_sources/room_service_source.dart';
import '../table_sources/rooms_used_table_source.dart';

class HandoverForm extends GetView<HandoverFormController> {
  const HandoverForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Scaffold(
              appBar: buildGlobalAppBar(context, appBarTitle: "Handover Form"),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 200),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // EmptyIllustration(),
                      RoomsUsedSection(),
                      ConferenceUsageSection(),
                      LaundryUsageSection(),
                      RoomServiceTransactionsSection(),
                      HotelIssuesSection(),
                      const HandoverDetailsForm(),
                    ],
                  ),
                ),
              ),
            ));
  }
}

class HandoverDetailsForm extends GetView<HandoverFormController> {
  const HandoverDetailsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class HotelIssuesSection extends GetView<HandoverFormController> {
  HotelIssuesSection({Key? key}) : super(key: key);

  final HotelIssuesSource _hotelIssuesSource = HotelIssuesSource();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BigText(
                          text: 'Hotel Issues',
                        ),
                        reportEntryHeader(
                            onRefreshEntries: controller.onInit,
                            title: "Hotel Issues",
                            onAddEntry: () {
                              buildDialog(context, 'Hotel Issue',
                                  const HotelIssuesForm(),
                                  width: 400,
                                  height: 600,
                                  alignment: Alignment.center);
                            },
                            onConfirmEntry: () {})
                      ],
                    ),
                    SfDataGrid(
                        source: _hotelIssuesSource,
                        columns: [
                      GridColumn(
                          columnName: 'ROOM NUMBER',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                      LocalKeys.kRoomNumber.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'ISSUE TYPE',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: "ISSUE TYPE"))),
                      GridColumn(
                          columnName: 'STATUS',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: "STATUS"))),
                      GridColumn(
                          columnName: 'DESCRIPTION',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDescription.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: 'STEPS TAKEN',
                          columnWidthMode: ColumnWidthMode.fill,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: 'STEPS TAKEN'))),
                    ]),
                  ],
                ),
              ),
            ));
  }
}

class LaundryUsageSection extends GetView<HandoverFormController> {
  LaundryUsageSection({Key? key}) : super(key: key);

  final LaundryTransactionsSource _laundryTransactionsSource =
      LaundryTransactionsSource();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BigText(
                          text: 'Laundry Transactions',
                        ),
                        reportEntryHeader(
                            onRefreshEntries: controller.onInit,
                            title: "Laundry Transactions",
                            onAddEntry: () {
                              // buildDialog(
                              //     context,
                              //     'LAUNDRY',
                              //     BookServiceForm(isRoom: 0,),
                              //     width: 700,
                              //     height: 600,
                              //     alignment: Alignment.center
                              // );
                              // Get.to(()=>CheckInView());
                            },
                            onConfirmEntry: () {})
                      ],
                    ),
                    SfDataGrid(source: _laundryTransactionsSource, columns: [
                      GridColumn(
                          columnName: 'ROOM NUMBER',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                      LocalKeys.kRoomNumber.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'CLIENT',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kClient.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'AMOUNT COLLECTED',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kAmount.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'SERVICE',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kService.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'EMPLOYEE',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kEmployee.tr.toUpperCase()))),
                    ]),
                  ],
                ),
              ),
            ));
  }
}

class RoomServiceTransactionsSection extends GetView<HandoverFormController> {
  RoomServiceTransactionsSection({Key? key}) : super(key: key);

  final RoomServiceSource _roomServiceSource = RoomServiceSource();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BigText(text: 'Room Service Transactions'),
                        reportEntryHeader(
                            onRefreshEntries: controller.onInit,
                            title: "Room Service Transactions",
                            onAddEntry: () {},
                            onConfirmEntry: () {}),
                      ],
                    ),
                    SfDataGrid(source: _roomServiceSource, columns: [
                      GridColumn(
                          columnName: 'ROOM NUMBER',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                      LocalKeys.kRoomNumber.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'CLIENT',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kClient.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'AMOUNT COLLECTED',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kAmount.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'SERVICE',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kService.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'EMPLOYEE',
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kEmployee.tr.toUpperCase()))),
                    ]),
                  ],
                ),
              ),
            ));
  }
}

class ConferenceUsageSection extends GetView<HandoverFormController> {
  ConferenceUsageSection({Key? key}) : super(key: key);

  final ConferenceUsageSource conferenceUsageSource = ConferenceUsageSource();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BigText(text: "Conference Usage Today"),
                        reportEntryHeader(
                            onRefreshEntries: controller.onInit,
                            title: "Conference Transactions",
                            onAddEntry: () {
                              buildDialog(
                                  context,
                                  'CONFERENCE',
                                  BookServiceForm(
                                    isRoom: 0,
                                  ),
                                  width: 700,
                                  height: 600,
                                  alignment: Alignment.center);
                              // Get.to(()=>CheckInView());
                            },
                            onConfirmEntry: () {}),
                      ],
                    ),
                    SfDataGrid(source: conferenceUsageSource, columns: [
                      GridColumn(
                          columnName: 'NAME',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kFullName.tr.toUpperCase()))),
                      GridColumn(
                          columnName: 'EVENT TYPE',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: 'EVENT TYPE'))),
                      GridColumn(
                          columnName: 'ADVANCE',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(text: 'ADVANCE'))),
                      GridColumn(
                          columnName: 'TOTAL COST',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                      LocalKeys.kTotalCost.tr.toUpperCase()))),
                    ]),
                  ],
                ),
              ),
            ));
  }
}

class RoomsUsedSection extends GetView<HandoverFormController> {
  RoomsUsedSection({Key? key}) : super(key: key);

  final RoomsUsedSource _roomSoldSource = RoomsUsedSource();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    /// Table Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BigText(text: "Rooms Sold Today"),
                        reportEntryHeader(
                            onRefreshEntries: controller.onInit,
                            title: "Rooms Sold",
                            onAddEntry: () {
                              buildDialog(context, 'Used Rooms Form',
                                  const RoomUsedForm(),
                                  height: 200, width: 350);
                              // Get.to(()=>CheckInView());
                            },
                            onConfirmEntry: () {}),
                      ],
                    ),
                    controller.initialized
                        ? SfDataGrid(
                            headerGridLinesVisibility: GridLinesVisibility.none,
                            isScrollbarAlwaysShown: true,
                            source: _roomSoldSource,
                            columns: <GridColumn>[
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: 'ROOM NUMBER',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kRoomNumber.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: 'AMOUNT',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kAmount.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: 'SOLD X',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kSoldX.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: 'EMPLOYEE',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kEmployee.tr
                                              .toUpperCase()))),
                            ],
                          )
                        : loadingAnimation(actionStatement: 'Initializing')
                  ],
                ),
              ),
            ));
  }
}

class RoomUsedForm extends GetView<HandoverFormController> {
  const RoomUsedForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
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
    required Function onConfirmEntry}) {
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
              onPressed: () {
                onRefreshEntries();
              },
              icon: Icon(Icons.refresh))
          //MyOutlinedButton(text: 'Update', onClick: onRefreshEntries,borderColor:ColorsManager.primary,),
        ],
      ),
    ],
  );
}
