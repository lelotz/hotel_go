import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/text/big_text.dart';
import '../controller/handover_form_controller.dart';
import 'package:get/get.dart';


class PettyCashTableSource extends DataGridSource{
  PettyCashTableSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedPettyCashTransactions.value =
        handoverFormController.pettyCashTransactions.value;
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
    if (startIndex < handoverFormController.pettyCashTransactions.value.length &&
        endIndex <= handoverFormController.pettyCashTransactions.value.length) {
      handoverFormController.paginatedPettyCashTransactions.value =
          handoverFormController.pettyCashTransactions.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedPettyCashTransactions.value = [];
    }

    return true;
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    handoverFormController.getSummaryData(summaryColumn!.columnName,summaryValue);
    return Center(child: BigText(text: summaryValue),);
  }

  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedPettyCashTransactions.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: PettyCashTableColumnNames.receiverName, value: dataGridRow.beneficiaryName),
        DataGridCell<String>(columnName: PettyCashTableColumnNames.department, value: dataGridRow.department),
        DataGridCell<String>(columnName: PettyCashTableColumnNames.employeeId, value: handoverFormController.userData.userData.value[dataGridRow.employeeId!]),
        DataGridCell<String>(columnName: PettyCashTableColumnNames.description, value: dataGridRow.description),
        DataGridCell<int>(columnName: PettyCashTableColumnNames.amountPaid, value: dataGridRow.transactionValue),


      ]);
    }).toList(growable: false);
  }
}

class PettyCashTableColumnNames{
  static const String leading = "petty_cash_";
  static const String employeeId = '${leading}employee';
  static const String receiverName = '${leading}receiver_name';
  static const String department = '${leading}department';
  static const String description = '${leading}description';
  static const String amountPaid = '${leading}amount_paid';
}