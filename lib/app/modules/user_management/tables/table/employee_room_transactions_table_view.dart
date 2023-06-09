import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/tables/sources/employee_room_transactions_source.dart';
import 'package:hotel_pms/app/modules/user_management/tables/table/table_constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../reports/view/hand_over_form_view.dart';
import '../../controller/user_profile_controller.dart';

class EmployeeRoomTransactionsTableView extends GetView<UserProfileController> {
  EmployeeRoomTransactionsTableView({Key? key})
      : super(key: key);

  final EmployeeRoomTransactionsSource tableSource = EmployeeRoomTransactionsSource();
  final GlobalKey<SfDataGridState> tableKey= GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(Get.context!).size.height;

    return GetBuilder<UserProfileController>(
        builder: (controller) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BigText(text: "Rooms Sold"),
                      tableHeader(
                          onRefreshEntries: ()async{
                            await controller.loadEmployeeRoomTransactions();
                            controller.updateUI();
                          },
                          title: "Rooms Sold",
                          onSave: () async {},
                          enableAddEntry: false,
                          enableConfirmEntry: false,
                          onAddEntry: () {},
                          onConfirmEntry: () {}
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * UserManagementTableConstants.tableHeightFactor,
                    //height: height * .62,

                    child: SfDataGrid(
                        key: tableKey,
                        source: tableSource,

                        columns: [
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.date,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kDate.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.time,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kTime.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.roomNumber,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kRoomNumber.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.checkIn,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'CHECK-IN'))),
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.checkOut,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'CHECK-OUT'))),
                          GridColumn(
                              columnName: EmployeeRoomTransactionsTableColumn.nights,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'NIGHTS'))),
                          GridColumn(
                              columnName:EmployeeRoomTransactionsTableColumn.value,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kValue.tr
                                          .toUpperCase()))),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
