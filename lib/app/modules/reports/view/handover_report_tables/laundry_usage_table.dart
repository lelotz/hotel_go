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
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
                        title: "Laundry Transactions",
                        onSave: () async {
                          controller.queTableKey(
                              laundryTableKey, "laundry");
                          await controller.processTableExports();
                        },
                        enableAddEntry: false,
                        enableConfirmEntry: false,
                        onAddEntry: () {},
                        onConfirmEntry: () {})
                  ],
                ),
                SfDataGrid(
                    key: laundryTableKey,
                    source: _laundryTransactionsSource,
                    shrinkWrapRows: true,
                    verticalScrollPhysics: NeverScrollableScrollPhysics(),
                    tableSummaryRows: [
                      GridTableSummaryRow(
                          showSummaryInRow: false,
                          title: '{Amount}{Service Count}{Total}{Debts}',
                          columns: [
                            const GridSummaryColumn(
                                name: 'Amount',
                                columnName: LaundryTableColumnNames.amountPaid,
                                summaryType: GridSummaryType.sum
                            ),
                            const GridSummaryColumn(
                                name: 'Service Count',
                                columnName: LaundryTableColumnNames.roomNumber,
                                summaryType: GridSummaryType.count
                            ),
                            const GridSummaryColumn(
                                name: 'Debts',
                                columnName: LaundryTableColumnNames.debt,
                                summaryType: GridSummaryType.sum
                            ),
                            const GridSummaryColumn(
                                name: 'Total',
                                columnName: LaundryTableColumnNames.total,
                                summaryType: GridSummaryType.sum
                            ),
                          ],
                          position: GridTableSummaryRowPosition.top
                      )
                    ],
                    columns: [
                      GridColumn(
                          columnName: LaundryTableColumnNames.date,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDate.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.time,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kTime.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.roomNumber,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kRoom.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.details,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDetails.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.action,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                  'KITENDO'))),

                      GridColumn(
                          columnName: LaundryTableColumnNames.total,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kTotal.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.amountPaid,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                  LocalKeys.kPaid.tr.toUpperCase()))),
                      GridColumn(
                          columnName: LaundryTableColumnNames.debt,
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