import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/text/big_text.dart';

class SalesTableSource extends DataGridSource{

  SalesTableSource({this.rowsPerPage = 20}){
    salesController.paginatedCollectedPayments.value = salesController.collectedPayments.value;
    buildPaginatedDataGridRows();
    print('paginatedSalesCount${salesController.paginatedCollectedPayments.value.length}');
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
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: BigText(text: summaryValue),
    );
  }
  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < salesController.collectedPayments.value.length && endIndex <= salesController.collectedPayments.value.length) {
      salesController.paginatedCollectedPayments.value =
          salesController.collectedPayments.value.getRange(startIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      // salesController.paginatedCollectedPayments.value = [];
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
        DataGridCell<String>(columnName: 'PAY METHOD', value: dataGridRow.payMethod!),
        DataGridCell<int>(columnName: 'COLLECTED', value: dataGridRow.amountCollected ?? -1),
      ]);

    }).toList(growable: false);
    print('DataGridRowsCount'+ dataGridRows.length.toString());
  }

}