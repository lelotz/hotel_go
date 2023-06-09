import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';



class EmployeeRoomTransactionsSource extends DataGridSource{
  EmployeeRoomTransactionsSource({this.rowsPerPage = 20}) {
    userProfileController.paginatedEmployeeRoomTransactions.value =
        userProfileController.employeeRoomTransactions.value;
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
    if (startIndex < userProfileController.employeeRoomTransactions.value.length &&
        endIndex <= userProfileController.employeeRoomTransactions.value.length) {
      userProfileController.paginatedEmployeeRoomTransactions.value =
          userProfileController.employeeRoomTransactions.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      userProfileController.paginatedEmployeeRoomTransactions.value = [];
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
    dataGridRows = userProfileController.paginatedEmployeeRoomTransactions.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: EmployeeRoomTransactionsTableColumn.date, value: extractDate(DateTime.parse(dataGridRow.checkInDate!))),
        DataGridCell<String>(
            columnName: EmployeeRoomTransactionsTableColumn.time, value: extractTime(DateTime.parse(dataGridRow.checkInDate!))),
        DataGridCell<int>(columnName: EmployeeRoomTransactionsTableColumn.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: EmployeeRoomTransactionsTableColumn.checkIn, value: extractTime(DateTime.parse(dataGridRow.checkInDate!))),
        DataGridCell<String>(columnName: EmployeeRoomTransactionsTableColumn.checkOut, value: extractTime(DateTime.parse(dataGridRow.checkOutDate!))),
        DataGridCell<int>(columnName: EmployeeRoomTransactionsTableColumn.nights, value: dataGridRow.nights),
        DataGridCell<int>(columnName: EmployeeRoomTransactionsTableColumn.value, value: dataGridRow.roomCost),
      ]);
    }).toList(growable: false);
  }
}

class EmployeeRoomTransactionsTableColumn{
  static const String leading = "employee_";
  static const String date = '${leading}name';
  static const String time = '${leading}time';
  static const String roomNumber = '${leading}room_number';
  static const String checkIn = '${leading}check_in';
  static const String checkOut = '${leading}check_out';
  static const String value = '${leading}value';
  static const String nights = '${leading}nights';

}