import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/handover_form_controller.dart';
import '../../table_sources/rooms_sold_collected_payment_in_session.dart';
import '../hand_over_form_view.dart';

class RoomsSoldPaymentsSection extends GetView<ReportGeneratorController> {
  RoomsSoldPaymentsSection({Key? key, required this.tableKey}) : super(key: key);

  final RoomsSoldCollectedPaymentSource _source = RoomsSoldCollectedPaymentSource();
  final GlobalKey<SfDataGridState> tableKey;
  final double minColumnWidth = 150;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
      // init: ReportGeneratorController(),
        builder: (controller) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// Table Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BigText(text: "Malipo ya Vyumba Vilivyouzwa Shifti hii"),
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
                        title: "Rooms Sold",
                        onSave: () async {
                          controller.queTableKey(tableKey, 'Rooms');
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
                SfDataGrid(
                  key: tableKey,
                  headerGridLinesVisibility: GridLinesVisibility.none,
                  isScrollbarAlwaysShown: true,
                  source: _source,
                  shrinkWrapRows: true,
                  verticalScrollPhysics: NeverScrollableScrollPhysics(),
                  tableSummaryRows: [
                    GridTableSummaryRow(
                        title: '{Rooms Sold}',
                        showSummaryInRow: false,
                        columns: const [
                          GridSummaryColumn(
                              name: "Rooms Sold",
                              columnName:RoomsSoldAndPaidColumnNamesCp.roomNumber,
                              summaryType: GridSummaryType.count),
                          GridSummaryColumn(
                              name: "Paid",
                              columnName:RoomsSoldAndPaidColumnNamesCp.paid,
                              summaryType: GridSummaryType.sum),
                        ],
                        position: GridTableSummaryRowPosition.top)
                  ],
                  columns: <GridColumn>[
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByColumnName,
                        columnName:RoomsSoldAndPaidColumnNamesCp.employee,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kEmployee.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByCellValue,
                        columnName:RoomsSoldAndPaidColumnNamesCp.date,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kDate.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode:
                        ColumnWidthMode.fitByCellValue,
                        columnName:RoomsSoldAndPaidColumnNamesCp.time,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kTime.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode: ColumnWidthMode.fitByColumnName,
                        columnName:RoomsSoldAndPaidColumnNamesCp.roomNumber,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kRoom.tr
                                    .toUpperCase()))),

                    GridColumn(
                      // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        minimumWidth: minColumnWidth,
                        columnName:RoomsSoldAndPaidColumnNamesCp.paid,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: LocalKeys.kPaid.tr
                                    .toUpperCase()))),
                    GridColumn(
                        columnWidthMode: ColumnWidthMode.fill,
                        //minimumWidth: minColumnWidth,
                        columnName:RoomsSoldAndPaidColumnNamesCp.id,
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: SmallText(
                                text: 'SessionID'
                                    .toUpperCase()))),
                  ],
                )
              ],
            ),
          ),
        ));
  }


}