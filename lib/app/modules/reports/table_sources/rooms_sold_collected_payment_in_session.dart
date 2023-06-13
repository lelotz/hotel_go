import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:hotel_pms/app/modules/user_data/controller/user_data_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/small_text.dart';

class RoomsSoldCollectedPaymentSource extends DataGridSource {
  RoomsSoldCollectedPaymentSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedRoomsSoldCollectedInCurrentSessionCp.value =
        handoverFormController.roomsSoldCollectedInCurrentSessionCp.value;
    buildPaginatedDataGridRows();
  }

  onInit()async{

  }

  ReportGeneratorController handoverFormController = Get.find<ReportGeneratorController>();
  UserData userData = Get.find<UserData>();

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
            child: SmallText(text: cell.value.toString(),selectable: cell.columnName==RoomsSoldAndPaidColumnNamesCp.id ? true:false,),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < handoverFormController.roomsSoldCollectedInCurrentSessionCp.value.length &&
        endIndex <= handoverFormController.roomsSoldCollectedInCurrentSessionCp.value.length) {
      handoverFormController.paginatedRoomsSoldCollectedInCurrentSessionCp.value =
          handoverFormController.roomsSoldCollectedInCurrentSessionCp.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedRoomsSoldCollectedInCurrentSessionCp.value = [];
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
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Center(
        child:  BigText(text: summaryValue),
      ),
    );
  }

  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedRoomsSoldCollectedInCurrentSessionCp.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: RoomsSoldAndPaidColumnNamesCp.employee, value: userData.userData.value[dataGridRow.employeeId] ??dataGridRow.employeeId ),
        DataGridCell<String>(columnName: RoomsSoldAndPaidColumnNamesCp.date, value: dataGridRow.date ),
        DataGridCell<String>(columnName: RoomsSoldAndPaidColumnNamesCp.time, value: dataGridRow.time ),
        DataGridCell<int>(columnName: RoomsSoldAndPaidColumnNamesCp.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<int>(columnName: RoomsSoldAndPaidColumnNamesCp.paid, value: dataGridRow.amountCollected),
        DataGridCell<String>(columnName: RoomsSoldAndPaidColumnNamesCp.id, value: dataGridRow.sessionId ),


        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);

  }
}

class RoomsSoldAndPaidColumnNamesCp{
  static const String leading = "";
  static const String employee = '${leading}employee';
  static const String roomNumber = 'room';
  static const String date = '${leading}date';

  static const String time = '${leading}time';
  static const String paid = '${leading}paid';
  static const String id = '${leading}session_id';
}
