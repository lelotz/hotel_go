import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SalesTableSource extends DataGridSource{

  SalesTableSource({this.rowsPerPage = 20}){
    salesController.paginatedCollectedPayments.value = salesController.collectedPayments.value;
  }
  SalesController salesController = Get.put(SalesController(),permanent: true);

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
    if (startIndex < salesController.collectedPayments.value.length && endIndex <= salesController.collectedPayments.value.length) {
      salesController.paginatedCollectedPayments.value =
          salesController.collectedPayments.value.getRange(startIndex as int, endIndex as int).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      salesController.paginatedCollectedPayments.value = [];
    }

    return true;
  }

  buildPaginatedDataGridRows(){
    int index = 0;
    dataGridRows = salesController.paginatedCollectedPayments.value.map<DataGridRow>((dataGridRow) {
      index++;
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: '#', value: index),
        DataGridCell<int>(columnName: 'ROOM NUMBER', value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: 'DATE', value: dataGridRow.date!),
        DataGridCell<String>(columnName: 'TIME', value: dataGridRow.time!),
        DataGridCell<String>(columnName: 'EMPLOYEE', value: dataGridRow.employeeName),
        DataGridCell<String>(columnName: 'CLIENT', value: dataGridRow.clientName),
        DataGridCell<String>(columnName: 'SERVICE', value: dataGridRow.service!),
        DataGridCell<int>(columnName: 'COLLECTED', value: dataGridRow.amountCollected),
        DataGridCell<String>(columnName: 'PAY METHOD', value: dataGridRow.payMethod!),
      ]);

    }).toList(growable: false);
  }

}