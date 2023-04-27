import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';



class EmployeeCollectedPaymentsSource extends DataGridSource{
  EmployeeCollectedPaymentsSource({this.rowsPerPage = 20}) {
    userProfileController.paginatedEmployeeCollectedPaymentsActivity.value =
        userProfileController.employeeCollectedPaymentsActivity.value;
    buildPaginatedDataGridRows();
  }



  UserProfileController userProfileController = Get.find<UserProfileController>();

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
            child: SmallText(text:cell.value.toString()),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < userProfileController.employeeCollectedPaymentsActivity.value.length &&
        endIndex <= userProfileController.employeeCollectedPaymentsActivity.value.length) {
      userProfileController.paginatedEmployeeCollectedPaymentsActivity.value =
          userProfileController.employeeCollectedPaymentsActivity.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      userProfileController.paginatedEmployeeCollectedPaymentsActivity.value = [];
    }

    return true;
  }
  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {

    return Center(child: BigText(text: summaryValue),);
  }


  buildPaginatedDataGridRows() {
    dataGridRows = userProfileController.paginatedEmployeeCollectedPaymentsActivity.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: EmployeeCollectedPaymentsTableColumn.date, value: extractDate(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(
            columnName: EmployeeCollectedPaymentsTableColumn.time, value: extractTime(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<int>(columnName: EmployeeCollectedPaymentsTableColumn.room_number, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: EmployeeCollectedPaymentsTableColumn.service, value: dataGridRow.service),
        DataGridCell<String>(columnName: EmployeeCollectedPaymentsTableColumn.payMethod, value: dataGridRow.payMethod),
        DataGridCell<int>(columnName: EmployeeCollectedPaymentsTableColumn.value, value: dataGridRow.amountCollected),
      ]);
    }).toList(growable: false);
  }
}

class EmployeeCollectedPaymentsTableColumn{
  static const String leading = "employee_";
  static const String date = '${leading}name';
  static const String time = '${leading}time';
  static const String room_number = '${leading}room_number';
  static const String service = '${leading}service';
  static const String value = '${leading}value';
  static const String payMethod = '${leading}pay_method';

}