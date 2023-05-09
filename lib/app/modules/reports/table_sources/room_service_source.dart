import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/small_text.dart';
import '../controller/handover_form_controller.dart';

class RoomServiceSource extends DataGridSource{
  RoomServiceSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedRoomServiceTransactionsInCurrentSession.value =
        handoverFormController.roomServiceTransactionsInCurrentSession.value;
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
    if (startIndex < handoverFormController.roomServiceTransactionsInCurrentSession.value.length &&
        endIndex <= handoverFormController.roomServiceTransactionsInCurrentSession.value.length) {
      handoverFormController.paginatedRoomServiceTransactionsInCurrentSession.value =
          handoverFormController.roomServiceTransactionsInCurrentSession.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedRoomServiceTransactionsInCurrentSession.value = [];
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
    return Container(
      padding: const EdgeInsets.all(1.0),
      child: Center(child: BigText(text: summaryValue),),
    );
  }

  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedRoomServiceTransactionsInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: RoomsServiceColumnNames.date, value: extractDate(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(columnName: RoomsServiceColumnNames.time, value: extractTime(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<int>(columnName: RoomsServiceColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: RoomsServiceColumnNames.details, value: dataGridRow.transactionNotes),
        DataGridCell<int>(columnName: RoomsServiceColumnNames.total, value: dataGridRow.grandTotal),
        DataGridCell<int>(columnName: RoomsServiceColumnNames.amountPaid, value: dataGridRow.amountPaid),
        DataGridCell<int>(columnName: RoomsServiceColumnNames.debt, value: dataGridRow.outstandingBalance),
      ]);
    }).toList(growable: false);
  }
}

class RoomsServiceColumnNames{
  static const String leading = "";
  static const String roomNumber = '${leading}room';
  static const String date = '${leading}date';
  static const String time = '${leading}time';
  static const String details = '${leading}details';
  static const String action = '${leading}action';
  static const String total = '${leading}total';
  static const String debt = '${leading}debt';
  static const String amountPaid = '${leading}amount_paid';
}