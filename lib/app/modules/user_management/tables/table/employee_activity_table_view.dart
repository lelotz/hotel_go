import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/app/modules/user_management/tables/sources/employee_activity_table_source.dart';
import 'package:hotel_pms/app/modules/user_management/tables/table/table_constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../reports/view/hand_over_form_view.dart';

class EmployeeTableView extends GetView<UserProfileController> {
  EmployeeTableView({Key? key}) : super(key: key);

  final EmployeeActivitySource source = EmployeeActivitySource();
  final GlobalKey<SfDataGridState>  employeeActivityTableKey = GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(Get.context!).size.height;
    return GetBuilder<UserProfileController>(
        builder: (controller)=>Card(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BigText(text: "Employee Activity"),
                  tableHeader(
                      onRefreshEntries: controller.loadUserActivity,
                      title: "Conference Transactions",
                      onSave: ()  {
                      },
                      onAddEntry: () {},
                      enableConfirmEntry: false,
                      enableAddEntry: false,
                      enableTableExport: false,
                      onConfirmEntry: () {}),
                ],
              ),
              SizedBox(
                 height: height * UserManagementTableConstants.tableHeightFactor,
                //height: height * .,

                child: SfDataGrid(
                    key: employeeActivityTableKey,
                    source: source,



                    columns: [
                      GridColumn(
                          columnName: EmployeeActivityTableColumnNames.date,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kDate.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: EmployeeActivityTableColumnNames.time,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kTime.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName: EmployeeActivityTableColumnNames.status,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: 'STATUS'))),
                      GridColumn(
                          columnName: EmployeeActivityTableColumnNames.description,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const SmallText(text: 'DESCRIPTION'))),
                      GridColumn(
                          columnName:EmployeeActivityTableColumnNames.unit,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: SmallText(
                                  text: LocalKeys.kUnit.tr
                                      .toUpperCase()))),
                      GridColumn(
                          columnName:EmployeeActivityTableColumnNames.value,
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
