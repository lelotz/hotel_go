import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../controller/handover_form_controller.dart';

class LaundryTransactionsSource extends DataGridSource{
  LaundryTransactionsSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedLaundryTransactionsInCurrentSession.value =
        handoverFormController.laundryTransactionsInCurrentSession.value;
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



  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedLaundryTransactionsInCurrentSession.value
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