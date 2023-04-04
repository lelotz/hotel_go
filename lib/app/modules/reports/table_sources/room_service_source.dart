import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../widgets/text/big_text.dart';
import '../controller/handover_form_controller.dart';

class RoomServiceSource extends DataGridSource{
  RoomServiceSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedRoomServiceTransactionsInCurrentSession.value =
        handoverFormController.roomServiceTransactionsInCurrentSession.value;
    buildPaginatedDataGridRows();
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
    handoverFormController.getSummaryData(summaryColumn?.columnName ?? '',summaryValue);
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
        DataGridCell<int>(columnName: RoomsServiceColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: RoomsServiceColumnNames.client, value: dataGridRow.clientName),
        DataGridCell<String>(columnName: RoomsServiceColumnNames.employee, value: dataGridRow.employeeName),
        DataGridCell<int>(columnName: RoomsServiceColumnNames.amountPaid, value: dataGridRow.amountCollected),
        DataGridCell<String>(columnName: RoomsServiceColumnNames.service, value: dataGridRow.service),
      ]);
    }).toList(growable: false);
  }
}

class RoomsServiceColumnNames{
  static const String leading = "rooms_service_";
  static const String employee = '${leading}employee';
  static const String roomNumber = '${leading}room_number';
  static const String client = '${leading}client';
  static const String service = '${leading}service';
  static const String amountPaid = '${leading}amount_paid';
}