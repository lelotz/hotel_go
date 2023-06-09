import 'package:flutter/material.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/small_text.dart';
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
            child: SmallText(text: cell.value.toString()),
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
    handoverFormController.getSummaryData(summaryColumn!.columnName,summaryValue);
    return Center(child: BigText(text: summaryValue),);
  }

  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedLaundryTransactionsInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: LaundryTableColumnNames.date, value: extractDate(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(columnName: LaundryTableColumnNames.time, value: extractTime(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<int>(columnName: LaundryTableColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: LaundryTableColumnNames.details, value: '${dataGridRow.transactionNotes!.split(':')[0]} ${dataGridRow.transactionNotes!.split(':')[1]}'),
        DataGridCell<String>(columnName: LaundryTableColumnNames.action, value: '${dataGridRow.transactionNotes!.split(':')[2]}'),
        DataGridCell<int>(columnName: LaundryTableColumnNames.total, value: dataGridRow.grandTotal),
        DataGridCell<int>(columnName: LaundryTableColumnNames.amountPaid, value: dataGridRow.amountPaid),
        DataGridCell<int>(columnName: LaundryTableColumnNames.debt, value: dataGridRow.outstandingBalance),

      ]);
    }).toList(growable: false);
  }
}

class LaundryTableColumnNames{
  static const String leading = "";
  static const String roomNumber = '${leading}room_number';
  static const String date = '${leading}date';
  static const String time = '${leading}time';
  static const String details = '${leading}details';
  static const String action = '${leading}action';
  static const String total = '${leading}total';
  static const String debt = '${leading}debt';
  static const String amountPaid = '${leading}amount_paid';
}