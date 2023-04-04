import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../widgets/text/big_text.dart';
import '../controller/handover_form_controller.dart';

class ConferenceUsageSource extends DataGridSource{
  ConferenceUsageSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedConferenceActivityCurrentSession.value =
        handoverFormController.conferenceActivityCurrentSession.value;
    buildPaginatedDataGridRows();
  }

  onInit()async{

  }

  HandoverFormController handoverFormController = Get.find<HandoverFormController>();

  List<DataGridRow> dataGridRows = [];

  int rowsPerPage;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            child: Text(cell.value.toString()),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < handoverFormController.conferenceActivityCurrentSession.value.length &&
        endIndex <= handoverFormController.conferenceActivityCurrentSession.value.length) {
      handoverFormController.paginatedConferenceActivityCurrentSession.value =
          handoverFormController.conferenceActivityCurrentSession.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedConferenceActivityCurrentSession.value = [];
    }

    return true;
  }
  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    handoverFormController.getSummaryData(summaryColumn?.columnName ?? '',summaryValue);
    return Center(child: BigText(text: summaryValue),);
  }


  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedConferenceActivityCurrentSession.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: ConferenceTableColumnNames.name, value: dataGridRow.name),
        DataGridCell<String>(columnName: ConferenceTableColumnNames.eventType, value: dataGridRow.bookingType),
        DataGridCell<String>(columnName: ConferenceTableColumnNames.advance, value: dataGridRow.advancePayment),
        DataGridCell<int>(columnName: ConferenceTableColumnNames.totalCost, value: dataGridRow.serviceValue),
        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);
  }
}

class ConferenceTableColumnNames{
  static const String leading = "conference_";
  static const String name = '${leading}name';
  static const String eventType = '${leading}event_type';
  static const String advance = '${leading}advance';
  static const String totalCost = '${leading}total_cost';

}