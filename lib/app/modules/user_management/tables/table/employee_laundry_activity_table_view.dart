import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/tables/table/table_constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../reports/view/hand_over_form_view.dart';
import '../../controller/user_profile_controller.dart';
import '../sources/employee_laundry_activity_source.dart';

class EmployeeLaundryActivityTableView extends GetView<UserProfileController> {
  EmployeeLaundryActivityTableView({Key? key})
      : super(key: key);

  final EmployeeLaundryActivitySource tableSource = EmployeeLaundryActivitySource();
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
                      const BigText(text: "Laundry"),
                      tableHeader(
                          onRefreshEntries: ()async{
                            await controller.loadEmployeeRoomTransactions();
                            controller.updateUI();
                          },
                          title: "Laundry",
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
                              columnName: EmployeeLaundryTableColumn.date,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kDate.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeLaundryTableColumn.time,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kTime.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeLaundryTableColumn.roomNumber,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: LocalKeys.kRoomNumber.tr
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeLaundryTableColumn.description,
                              columnWidthMode: ColumnWidthMode.fitByColumnName,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'DESCRIPTION'))),
                          GridColumn(
                              columnName: EmployeeLaundryTableColumn.status,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'STATUS'))),

                          GridColumn(
                              columnName:EmployeeLaundryTableColumn.value,
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
