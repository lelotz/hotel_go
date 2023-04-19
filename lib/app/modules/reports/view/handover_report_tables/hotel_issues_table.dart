import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/dialogs/dialod_builder.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../widgtes/forms/hotel_issues_form.dart';
import '../../controller/handover_form_controller.dart';
import '../../table_sources/hotel_issues_source.dart';
import '../hand_over_form_view.dart';

class HotelIssuesSection extends GetView<ReportGeneratorController> {
  HotelIssuesSection({Key? key, required this.hotelIssuesTableKey})
      : super(key: key);

  final HotelIssuesSource _hotelIssuesSource = HotelIssuesSource();
  final GlobalKey<SfDataGridState> hotelIssuesTableKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
        //init: ReportGeneratorController(),
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
                        onRefreshEntries: controller.loadReportData,
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