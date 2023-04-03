import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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



  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedRoomServiceTransactionsInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ROOM NUMBER', value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: 'CLIENT', value: dataGridRow.clientName),
        DataGridCell<int>(columnName: 'AMOUNT PAID', value: dataGridRow.amountCollected),
        DataGridCell<String>(columnName: 'SERVICE', value: dataGridRow.service),
        DataGridCell<String>(columnName: 'EMPLOYEE', value: dataGridRow.employeeName),
      ]);
    }).toList(growable: false);
  }
}