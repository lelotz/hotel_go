import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';



class EmployeeSessionsSource extends DataGridSource{
  EmployeeSessionsSource({this.rowsPerPage = 20}) {
    userProfileController.paginatedEmployeeSessionsTrackerActivity.value =
        userProfileController.employeeSessionsTrackerActivity.value;
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
            child: SmallText(text:cell.value.toString(),selectable: cell.columnName == EmployeeSessionTrackerTableColumn.sessionId ? true : false,),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < userProfileController.employeeSessionsTrackerActivity.value.length &&
        endIndex <= userProfileController.employeeSessionsTrackerActivity.value.length) {
      userProfileController.paginatedEmployeeSessionsTrackerActivity.value =
          userProfileController.employeeSessionsTrackerActivity.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      userProfileController.paginatedEmployeeSessionsTrackerActivity.value = [];
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
    dataGridRows = userProfileController.paginatedEmployeeSessionsTrackerActivity.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: EmployeeSessionTrackerTableColumn.dateCreated, value: "${extractDate(DateTime.parse(dataGridRow.dateCreated!))} ${extractTime(DateTime.parse(dataGridRow.dateCreated!))}"),
        DataGridCell<String>(
            columnName: EmployeeSessionTrackerTableColumn.dateEnded, value: dataGridRow.dateEnded == null ? "ONGOING" : "${extractDate(DateTime.parse(dataGridRow.dateEnded!))} ${extractTime(DateTime.parse(dataGridRow.dateEnded!))}"),
        DataGridCell<String>(
            columnName: EmployeeSessionTrackerTableColumn.status, value: dataGridRow.sessionStatus),

        DataGridCell<String>(columnName: EmployeeSessionTrackerTableColumn.sessionId, value: dataGridRow.id),

      ]);
    }).toList(growable: false);
  }
}

class EmployeeSessionTrackerTableColumn{
  static const String leading = "session_tracker";
  static const String dateCreated = '${leading}date_created';
  static const String dateEnded = '${leading}date_ended';
  static const String sessionId = '${leading}room_number';
  static const String status = '${leading}status';

}