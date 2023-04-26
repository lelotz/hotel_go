import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';



class EmployeeRoomTransactionsSource extends DataGridSource{
  EmployeeRoomTransactionsSource({this.rowsPerPage = 20}) {
    userProfileController.paginatedUserActivity.value =
        userProfileController.userActivity.value;
    buildPaginatedDataGridRows();
  }

  onInit()async{

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
    if (startIndex < userProfileController.userActivity.value.length &&
        endIndex <= userProfileController.userActivity.value.length) {
      userProfileController.paginatedUserActivity.value =
          userProfileController.userActivity.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      userProfileController.paginatedUserActivity.value = [];
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
    dataGridRows = userProfileController.paginatedUserActivity.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: EmployeeActivityTableColumnNames.date, value: extractDate(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(
            columnName: EmployeeActivityTableColumnNames.time, value: extractTime(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(columnName: EmployeeActivityTableColumnNames.status, value: dataGridRow.activityStatus),
        DataGridCell<String>(columnName: EmployeeActivityTableColumnNames.description, value: dataGridRow.description),
        DataGridCell<String>(columnName: EmployeeActivityTableColumnNames.unit, value: dataGridRow.unit),
        DataGridCell<int>(columnName: EmployeeActivityTableColumnNames.value, value: dataGridRow.activityValue),
        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);
  }
}

class EmployeeActivityTableColumnNames{
  static const String leading = "employee_";
  static const String date = '${leading}name';
  static const String time = '${leading}time';
  static const String status = '${leading}status';
  static const String description = '${leading}description';
  static const String value = '${leading}value';
  static const String unit = '${leading}unit';

}