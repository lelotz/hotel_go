import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';



class EmployeeLaundryActivitySource extends DataGridSource{
  EmployeeLaundryActivitySource({this.rowsPerPage = 20}) {
    userProfileController.paginatedEmployeeLaundryActivity.value =
        userProfileController.employeeLaundryActivity.value;
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
    if (startIndex < userProfileController.employeeLaundryActivity.value.length &&
        endIndex <= userProfileController.employeeLaundryActivity.value.length) {
      userProfileController.paginatedEmployeeLaundryActivity.value =
          userProfileController.employeeLaundryActivity.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      userProfileController.paginatedEmployeeLaundryActivity.value = [];
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
    dataGridRows = userProfileController.paginatedEmployeeLaundryActivity.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: EmployeeLaundryTableColumn.date, value: extractDate(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<String>(
            columnName: EmployeeLaundryTableColumn.time, value: extractTime(DateTime.parse(dataGridRow.dateTime!))),
        DataGridCell<int>(columnName: EmployeeLaundryTableColumn.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: EmployeeLaundryTableColumn.description, value: '${dataGridRow.transactionNotes!.split(':')[0]} ${dataGridRow.transactionNotes!.split(':')[1]}'),
        DataGridCell<String>(columnName: EmployeeLaundryTableColumn.status, value: dataGridRow.transactionNotes!.split(':')[2]),
        DataGridCell<int>(columnName: EmployeeLaundryTableColumn.value, value: dataGridRow.grandTotal),
      ]);
    }).toList(growable: false);
  }
}

class EmployeeLaundryTableColumn{
  static const String leading = "employee_";
  static const String date = '${leading}name';
  static const String time = '${leading}time';
  static const String roomNumber = '${leading}room_number';
  static const String status = '${leading}status';
  static const String description = '${leading}description';
  static const String value = '${leading}value';

}