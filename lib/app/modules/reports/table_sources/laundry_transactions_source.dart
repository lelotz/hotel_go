import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../../../../widgets/text/big_text.dart';
import '../controller/handover_form_controller.dart';

class LaundryTransactionsSource extends DataGridSource{
  LaundryTransactionsSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedLaundryTransactionsInCurrentSession.value =
        handoverFormController.laundryTransactionsInCurrentSession.value;
    buildPaginatedDataGridRows();
  }



  ReportGeneratorController handoverFormController = Get.find<ReportGeneratorController>();

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
    if (startIndex < handoverFormController.laundryTransactionsInCurrentSession.value.length &&
        endIndex <= handoverFormController.laundryTransactionsInCurrentSession.value.length) {
      handoverFormController.paginatedLaundryTransactionsInCurrentSession.value =
          handoverFormController.laundryTransactionsInCurrentSession.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedLaundryTransactionsInCurrentSession.value = [];
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
        .paginatedLaundryTransactionsInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: LaundryTableColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: LaundryTableColumnNames.client, value: dataGridRow.clientName),
        DataGridCell<String>(columnName: LaundryTableColumnNames.employee, value: dataGridRow.employeeName),
        DataGridCell<int>(columnName: LaundryTableColumnNames.amountPaid, value: dataGridRow.amountCollected),
        DataGridCell<String>(columnName: LaundryTableColumnNames.service, value: dataGridRow.service),

      ]);
    }).toList(growable: false);
  }
}

class LaundryTableColumnNames{
  static const String leading = "laundry_";
  static const String employee = '${leading}employee';
  static const String roomNumber = '${leading}room_number';
  static const String client = '${leading}client';
  static const String service = '${leading}service';
  static const String amountPaid = '${leading}amount_paid';
}