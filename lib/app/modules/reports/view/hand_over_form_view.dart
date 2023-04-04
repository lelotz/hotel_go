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

class HandoverReport extends GetView<HandoverFormController> {
  HandoverReport({Key? key}) : super(key: key);

  final GlobalKey<SfDataGridState> hotelIssuesTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> roomServiceTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> laundryTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> conferenceTableKey =
      GlobalKey<SfDataGridState>();
  final GlobalKey<SfDataGridState> roomsTableKey = GlobalKey<SfDataGridState>();

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
                      Row(
                        children: [
                          const BigText(text: "Export Report"),
                          Obx(() => controller.isExporting.value
                              ? loadingAnimation()
                              : IconButton(
                                  onPressed: () async {
                                    controller.queTableKey(
                                        roomsTableKey, "Rooms");
                                    controller.queTableKey(
                                        conferenceTableKey, "Conference");
                                    controller.queTableKey(
                                        roomServiceTableKey, "Room Service");
                                    controller.queTableKey(
                                        laundryTableKey, "Laundry");
                                    controller.queTableKey(
                                        hotelIssuesTableKey, "Hotel Issues");

                                    await controller.processTableExports();
                                  },
                                  icon: const Icon(Icons.save_alt_outlined)))
                        ],
                      ),
                      RoomsUsedSection(
                        roomsTableKey: roomsTableKey,
                      ),
                      ConferenceUsageSection(
                        conferenceTableKey: conferenceTableKey,
                      ),
                      LaundryUsageSection(
                        laundryTableKey: laundryTableKey,
                      ),
                      RoomServiceTransactionsSection(
                        roomServiceTableKey: roomServiceTableKey,
                      ),
                      HotelIssuesSection(
                        hotelIssuesTableKey: hotelIssuesTableKey,
                      ),
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
  HotelIssuesSection({Key? key, required this.hotelIssuesTableKey})
      : super(key: key);

  final HotelIssuesSource _hotelIssuesSource = HotelIssuesSource();
  final GlobalKey<SfDataGridState> hotelIssuesTableKey;

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
                            onRefreshEntries: controller.update,
                            onSave: () async {
                              controller.queTableKey(
                                  hotelIssuesTableKey, "hotel_issues");
                              await controller.processTableExports();
                            },
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
                        key: hotelIssuesTableKey,
                        columns: [
                          GridColumn(
                              columnName: HotelIssuesTableColumnNames.roomNumber,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kRoomNumber.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: HotelIssuesTableColumnNames.issueType,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: "ISSUE TYPE"))),
                          GridColumn(
                              columnName: HotelIssuesTableColumnNames.status,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: "STATUS"))),
                          GridColumn(
                              columnName: HotelIssuesTableColumnNames.description,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kDescription.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: HotelIssuesTableColumnNames.stepsTaken,
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
  LaundryUsageSection({Key? key, required this.laundryTableKey})
      : super(key: key);

  final LaundryTransactionsSource _laundryTransactionsSource =
      LaundryTransactionsSource();
  final GlobalKey<SfDataGridState> laundryTableKey;

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
                            onSave: () async {
                              controller.queTableKey(
                                  laundryTableKey, "laundry");
                              await controller.processTableExports();
                            },
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
                    SfDataGrid(
                        key: laundryTableKey,
                        source: _laundryTransactionsSource,
                        tableSummaryRows: [
                          GridTableSummaryRow(
                              showSummaryInRow: false,
                              title: '{Amount}{Service Count}',
                              columns: [
                                const GridSummaryColumn(
                                    name: 'Amount',
                                    columnName: LaundryTableColumnNames.amountPaid,
                                    summaryType: GridSummaryType.sum
                                ),
                                const GridSummaryColumn(
                                    name: 'Service Count',
                                    columnName: LaundryTableColumnNames.service,
                                    summaryType: GridSummaryType.count
                                ),
                              ],
                              position: GridTableSummaryRowPosition.top
                          )
                        ],
                        columns: [
                          GridColumn(
                              columnName: LaundryTableColumnNames.roomNumber,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kRoomNumber.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: LaundryTableColumnNames.client,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text:
                                      LocalKeys.kClient.tr.toUpperCase()))),

                          GridColumn(
                              columnName: LaundryTableColumnNames.employee,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kEmployee.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: LaundryTableColumnNames.amountPaid,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text:
                                      LocalKeys.kAmount.tr.toUpperCase()))),
                          GridColumn(
                              columnName: LaundryTableColumnNames.service,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kService.tr
                                          .toUpperCase()))),
                        ]),
                  ],
                ),
              ),
            ));
  }
}

class RoomServiceTransactionsSection extends GetView<HandoverFormController> {
  RoomServiceTransactionsSection({Key? key, required this.roomServiceTableKey})
      : super(key: key);

  final RoomServiceSource _roomServiceSource = RoomServiceSource();
  final GlobalKey<SfDataGridState> roomServiceTableKey;

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
                            onSave: () async {
                              controller.queTableKey(
                                  roomServiceTableKey, 'Room Service');
                              await controller.processTableExports();
                            },
                            onAddEntry: () {},
                            onConfirmEntry: () {}),
                      ],
                    ),
                    SfDataGrid(
                        key: roomServiceTableKey,
                        source: _roomServiceSource,
                        tableSummaryRows: [
                          GridTableSummaryRow(
                            showSummaryInRow: false,
                            title: '{Amount}{Service Count}',
                              columns: [
                                const GridSummaryColumn(
                                    name: 'Amount',
                                    columnName: RoomsServiceColumnNames.amountPaid,
                                    summaryType: GridSummaryType.sum
                                ),
                                const GridSummaryColumn(
                                    name: 'Service Count',
                                    columnName: RoomsServiceColumnNames.service,
                                    summaryType: GridSummaryType.count
                                ),
                              ],
                              position: GridTableSummaryRowPosition.top
                          )
                        ],
                        columns: [
                          GridColumn(
                              columnName: RoomsServiceColumnNames.roomNumber,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kRoomNumber.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: RoomsServiceColumnNames.client,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text:
                                          LocalKeys.kClient.tr.toUpperCase()))),

                          GridColumn(
                              columnName: RoomsServiceColumnNames.employee,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kEmployee.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: RoomsServiceColumnNames.amountPaid,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text:
                                      LocalKeys.kAmount.tr.toUpperCase()))),
                          GridColumn(
                              columnName: RoomsServiceColumnNames.service,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kService.tr
                                          .toUpperCase()))),
                        ]),
                  ],
                ),
              ),
            ));
  }
}

class ConferenceUsageSection extends GetView<HandoverFormController> {
  ConferenceUsageSection({Key? key, required this.conferenceTableKey})
      : super(key: key);

  final ConferenceUsageSource conferenceUsageSource = ConferenceUsageSource();
  final GlobalKey<SfDataGridState> conferenceTableKey;

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
                            onSave: () async {
                              controller.queTableKey(
                                  conferenceTableKey, 'Conference');
                              await controller.processTableExports();
                            },
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
                    SfDataGrid(
                        key: conferenceTableKey,
                        source: conferenceUsageSource,
                        tableSummaryRows: [
                          GridTableSummaryRow(
                            showSummaryInRow: false,
                            title: '{Client}',
                              columns: [
                                const GridSummaryColumn(
                                    name: 'Client',
                                    columnName: ConferenceTableColumnNames.eventType,
                                    summaryType: GridSummaryType.count
                                ),
                                const GridSummaryColumn(
                                    name: 'Advance',
                                    columnName: ConferenceTableColumnNames.advance,
                                    summaryType: GridSummaryType.sum,
                                ),
                                const GridSummaryColumn(
                                    name: 'Value',
                                    columnName: ConferenceTableColumnNames.totalCost,
                                    summaryType: GridSummaryType.sum
                                ),
                              ],
                              position: GridTableSummaryRowPosition.top
                          )
                        ],
                        columns: [
                          GridColumn(
                              columnName: ConferenceTableColumnNames.name,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kFullName.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: ConferenceTableColumnNames.eventType,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'EVENT TYPE'))),
                          GridColumn(
                              columnName: ConferenceTableColumnNames.advance,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'ADVANCE'))),
                          GridColumn(
                              columnName:ConferenceTableColumnNames.totalCost,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kTotalCost.tr
                                          .toUpperCase()))),
                        ]),
                  ],
                ),
              ),
            ));
  }
}

class RoomsUsedSection extends GetView<HandoverFormController> {
  RoomsUsedSection({Key? key, required this.roomsTableKey}) : super(key: key);

  final RoomsUsedSource _roomSoldSource = RoomsUsedSource();
  final GlobalKey<SfDataGridState> roomsTableKey;
  final double minColumnWidth = 150;

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
                            onSave: () async {
                              controller.queTableKey(roomsTableKey, 'Rooms');
                              await controller.processTableExports();
                            },
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
                            key: roomsTableKey,
                            headerGridLinesVisibility: GridLinesVisibility.none,
                            isScrollbarAlwaysShown: true,
                            source: _roomSoldSource,
                            tableSummaryRows: [
                              GridTableSummaryRow(
                                  title: '{Rooms Sold}',
                                  showSummaryInRow: false,
                                  columns: const [
                                    GridSummaryColumn(
                                        name: "Rooms Sold",
                                        columnName: RoomsUsedColumnNames.roomNumber,
                                        summaryType: GridSummaryType.count),
                                     GridSummaryColumn(
                                        name: "Value",
                                        columnName: RoomsUsedColumnNames.value,
                                        summaryType: GridSummaryType.sum),
                                     GridSummaryColumn(
                                        name: "Paid",
                                        columnName: RoomsUsedColumnNames.paid,
                                        summaryType: GridSummaryType.sum),
                                    GridSummaryColumn(
                                        name: "Debts",
                                        columnName: RoomsUsedColumnNames.debt,
                                        summaryType: GridSummaryType.sum),
                                  ],
                                  position: GridTableSummaryRowPosition.top)
                            ],
                            columns: <GridColumn>[
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: RoomsUsedColumnNames.employee,
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kEmployee.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  columnWidthMode:
                                      ColumnWidthMode.fitByColumnName,
                                  columnName: RoomsUsedColumnNames.roomNumber,
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kRoomNumber.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  minimumWidth: minColumnWidth,
                                  columnName: RoomsUsedColumnNames.value,
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kValue.tr
                                              .toUpperCase()))),
                              GridColumn(
                                  // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                  minimumWidth: minColumnWidth,
                                  columnName: RoomsUsedColumnNames.paid,
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kPaid.tr
                                              .toUpperCase()))),
                              GridColumn(
                                // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                  minimumWidth: minColumnWidth,
                                  columnName: RoomsUsedColumnNames.debt,
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                          text: LocalKeys.kDebts.tr
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
              onPressed: () {
                onRefreshEntries();
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
