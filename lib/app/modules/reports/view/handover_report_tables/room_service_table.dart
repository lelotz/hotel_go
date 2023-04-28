import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/handover_form_controller.dart';

import '../../table_sources/room_service_source.dart';
import '../hand_over_form_view.dart';

class RoomServiceTransactionsSection extends GetView<ReportGeneratorController> {
  RoomServiceTransactionsSection({Key? key, required this.roomServiceTableKey})
      : super(key: key);

  final RoomServiceSource _roomServiceSource = RoomServiceSource();
  final GlobalKey<SfDataGridState> roomServiceTableKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
       // init: ReportGeneratorController(),
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
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
                        title: "Room Service Transactions",
                        onSave: () async {
                          controller.queTableKey(
                              roomServiceTableKey, 'Room Service');
                          await controller.processTableExports();
                        },
                        enableAddEntry: false,
                        enableConfirmEntry: false,
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
                          title: '{Amount}{Service Count}{Total}{Debts}',
                          columns: [
                            const GridSummaryColumn(
                                name: 'Amount',
                                columnName: RoomsServiceColumnNames.amountPaid,
                                summaryType: GridSummaryType.sum
                            ),
                            const GridSummaryColumn(
                                name: 'Service Count',
                                columnName: RoomsServiceColumnNames.roomNumber,
                                summaryType: GridSummaryType.count
                            ),
                            const GridSummaryColumn(
                                name: 'Debts',
                                columnName: RoomsServiceColumnNames.debt,
                                summaryType: GridSummaryType.sum
                            ),
                            const GridSummaryColumn(
                                name: 'Total',
                                columnName: RoomsServiceColumnNames.total,
                                summaryType: GridSummaryType.sum
                            ),
                          ],
                          position: GridTableSummaryRowPosition.top
                      )
                    ],
                    columns: [
                      GridColumn(
                          columnName: RoomsServiceColumnNames.date,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDate.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: RoomsServiceColumnNames.time,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kTime.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: RoomsServiceColumnNames.roomNumber,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kRoom.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: RoomsServiceColumnNames.details,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDetails.tr
                                      .toUpperCase()))),


                      GridColumn(
                          columnName: RoomsServiceColumnNames.total,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kTotal.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: RoomsServiceColumnNames.amountPaid,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                  LocalKeys.kPaid.tr.toUpperCase()))),
                      GridColumn(
                          columnName: RoomsServiceColumnNames.debt,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDebts.tr
                                      .toUpperCase()))),
                    ]),
              ],
            ),
          ),
        ));
  }
}