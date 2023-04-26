import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/petty_cash_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../controller/handover_form_controller.dart';
import '../hand_over_form_view.dart';

class PettyCashUsageSection extends GetView<ReportGeneratorController> {
  PettyCashUsageSection({Key? key, required this.pettyCashTableKey})
      : super(key: key);

  final PettyCashTableSource _pettyCashTableSource =
  PettyCashTableSource();
  final GlobalKey<SfDataGridState> pettyCashTableKey;

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
                      text: 'Petty Cash',
                    ),
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
                        title: "Petty Cash Transactions",
                        onSave: () async {
                          controller.queTableKey(
                              pettyCashTableKey, "Petty Cash");
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
                    key: pettyCashTableKey,
                    source: _pettyCashTableSource,
                    tableSummaryRows: [
                      GridTableSummaryRow(
                          showSummaryInRow: false,
                          title: '{Amount}',
                          columns: [
                            const GridSummaryColumn(
                                name: 'Amount',
                                columnName: PettyCashTableColumnNames.amountPaid,
                                summaryType: GridSummaryType.sum
                            ),

                          ],
                          position: GridTableSummaryRowPosition.top
                      )
                    ],
                    columns: [
                      GridColumn(
                          columnName: PettyCashTableColumnNames.receiverName,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(
                                  text:
                                  'RECEIVER'))),
                      GridColumn(
                          columnName: PettyCashTableColumnNames.department,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: 'Department'
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: PettyCashTableColumnNames.employeeId,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kEmployee.tr
                                      .toUpperCase()))),


                      GridColumn(
                          columnName: PettyCashTableColumnNames.description,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                  LocalKeys.kDescription.tr.toUpperCase()))),
                      GridColumn(
                          columnName: PettyCashTableColumnNames.amountPaid,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text:
                                  LocalKeys.kAmount.tr.toUpperCase()))),
                    ]),
              ],
            ),
          ),
        ));
  }
}