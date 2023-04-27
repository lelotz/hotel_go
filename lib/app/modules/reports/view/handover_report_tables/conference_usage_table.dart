import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../book_service/view/book_service_form.dart';
import '../../controller/handover_form_controller.dart';
import '../../table_sources/conference_usage_source.dart';

import '../hand_over_form_view.dart';
class ConferenceUsageSection extends GetView<ReportGeneratorController> {
  ConferenceUsageSection({Key? key, required this.conferenceTableKey})
      : super(key: key);

  final ConferenceUsageSource conferenceUsageSource = ConferenceUsageSource();
  final GlobalKey<SfDataGridState> conferenceTableKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        // init: ReportGeneratorController(),
        builder: (controller) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BigText(text: "Conference Usage Today"),
                    tableHeader(
                        onRefreshEntries: controller.loadReportData,
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
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
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
