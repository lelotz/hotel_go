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
                    reportEntryHeader(
                        onRefreshEntries: controller.loadReportData,
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