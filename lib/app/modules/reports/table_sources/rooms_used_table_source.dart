import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:hotel_pms/app/modules/user_data/controller/user_data_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/small_text.dart';

class RoomsUsedSource extends DataGridSource {
  RoomsUsedSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedRoomsSoldInCurrentSession.value =
        handoverFormController.roomsSoldInCurrentSession.value;
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
            child: SmallText(text: cell.value.toString()),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < handoverFormController.roomsSoldInCurrentSession.value.length &&
        endIndex <= handoverFormController.roomsSoldInCurrentSession.value.length) {
      handoverFormController.paginatedRoomsSoldInCurrentSession.value =
          handoverFormController.roomsSoldInCurrentSession.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedRoomsSoldInCurrentSession.value = [];
    }

    return true;
  }

  Future<AdminUser> getEmployeeById(String id) async {
    AdminUser adminUser = AdminUser();
    await AdminUserRepository().getAdminUserById(id).then((value) {
      if (value != null && value.isNotEmpty) {
        adminUser = AdminUser.fromJson(value.first);
      }
    });

    return adminUser;
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
        .paginatedRoomsSoldInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: RoomsUsedColumnNames.employee, value: userData.userData.value[dataGridRow.employeeId] ??dataGridRow.employeeId ),
        DataGridCell<int>(columnName: RoomsUsedColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: RoomsUsedColumnNames.checkInDate, value: extractDate(DateTime.parse(dataGridRow.checkInDate!)) ),
        DataGridCell<int>(columnName: RoomsUsedColumnNames.value, value: dataGridRow.roomCost!),
        DataGridCell<int>(columnName: RoomsUsedColumnNames.paid, value: dataGridRow.roomAmountPaid),
        DataGridCell<int>(columnName: RoomsUsedColumnNames.debt, value: dataGridRow.roomOutstandingBalance),

        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);

  }
}

class RoomsUsedColumnNames{
  static const String leading = "";
  static const String employee = '${leading}employee';
  static const String roomNumber = 'room';
  static const String checkInDate = '${leading}check_in_date';
  static const String value = '${leading}value';
  static const String paid = '${leading}paid';
  static const String debt = '${leading}debt';
}
