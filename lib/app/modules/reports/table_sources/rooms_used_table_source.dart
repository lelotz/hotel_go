import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RoomsUsedSource extends DataGridSource {
  RoomsUsedSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedRoomsSoldInCurrentSession.value =
        handoverFormController.roomsSoldInCurrentSession.value;
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

  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedRoomsSoldInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {

      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'ROOM NUMBER', value: dataGridRow.roomNumber),
        DataGridCell<int>(columnName: 'AMOUNT', value: dataGridRow.roomCost!),
        DataGridCell<String>(columnName: 'SOLD X', value: dataGridRow.time!),
        DataGridCell<String>(columnName: 'EMPLOYEE', value: dataGridRow.employeeId),
        // DataGridCell<String>(columnName: 'GUEST', value: dataGridRow.clientId),
      ]);
    }).toList(growable: false);
  }
}
