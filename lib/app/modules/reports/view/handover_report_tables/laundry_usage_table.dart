import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/handover_form_controller.dart';
import '../../table_sources/laundry_transactions_source.dart';
import '../hand_over_form_view.dart';

class LaundryUsageSection extends GetView<ReportGeneratorController> {
  LaundryUsageSection({Key? key, required this.laundryTableKey})
      : super(key: key);

  final LaundryTransactionsSource _laundryTransactionsSource =
  LaundryTransactionsSource();
  final GlobalKey<SfDataGridState> laundryTableKey;

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
                    const BigText(
                      text: 'Laundry Transactions',
                    ),
                    reportEntryHeader(
                        onRefreshEntries: controller.initData,
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