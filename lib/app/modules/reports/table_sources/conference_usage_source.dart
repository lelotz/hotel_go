import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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



  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedConferenceActivityCurrentSession.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'NAME', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'EVENT TYPE', value: dataGridRow.bookingType),
        DataGridCell<String>(columnName: 'ADVANCE', value: dataGridRow.advancePayment),
        DataGridCell<int>(columnName: 'TOTAL COST', value: dataGridRow.serviceValue),
        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);
  }
}