import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../../widgets/loading_animation/loading_animation.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/handover_form_controller.dart';
import '../../table_sources/rooms_occupied_source.dart';
import '../hand_over_form_view.dart';

class RoomsOccupiedSection extends GetView<ReportGeneratorController> {
  RoomsOccupiedSection({Key? key, required this.roomsTableKey}) : super(key: key);

  final RoomsOccupiedSource _roomsOccupiedSource = RoomsOccupiedSource();

  final GlobalKey<SfDataGridState> roomsTableKey;
  final double minColumnWidth = 150;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        builder: (controller) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// Table Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BigText(text: "Vyumba Vilivyo na Watu"),
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
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
                  source: _roomsOccupiedSource,
                  shrinkWrapRows: true,
                  verticalScrollPhysics: NeverScrollableScrollPhysics(),
                  tableSummaryRows: [
                    GridTableSummaryRow(
                        title: '{Rooms Sold}',
                        showSummaryInRow: false,
                        columns: const [
                          GridSummaryColumn(
                              name: "Rooms Sold",
                              columnName: RoomsOccupiedColumnNames.roomNumber,
                              summaryType: GridSummaryType.count),
                          GridSummaryColumn(
                              name: "Value",
                              columnName: RoomsOccupiedColumnNames.value,
                              summaryType: GridSummaryType.sum),
                          GridSummaryColumn(
                              name: "Paid",
                              columnName: RoomsOccupiedColumnNames.paid,
                              summaryType: GridSummaryType.sum),
                          GridSummaryColumn(
                              name: "Debts",
                              columnName: RoomsOccupiedColumnNames.debt,
                              summaryType: GridSummaryType.sum),
                        ],
                        position: GridTableSummaryRowPosition.top)
                  ],
                  columns: <GridColumn>[
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByColumnName,
                        columnName: RoomsOccupiedColumnNames.employee,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kEmployee.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByColumnName,
                        columnName: RoomsOccupiedColumnNames.roomNumber,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kRoom.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByColumnName,
                        columnName: RoomsOccupiedColumnNames.checkInDate,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kCheckIn.tr
                                    .toUpperCase()))),
                    GridColumn(
                        minimumWidth: minColumnWidth,
                        columnName: RoomsOccupiedColumnNames.value,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kValue.tr
                                    .toUpperCase()))),
                    GridColumn(
                      // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        minimumWidth: minColumnWidth,
                        columnName: RoomsOccupiedColumnNames.paid,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kPaid.tr
                                    .toUpperCase()))),
                    GridColumn(
                      // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        minimumWidth: minColumnWidth,
                        columnName: RoomsOccupiedColumnNames.debt,
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