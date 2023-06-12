import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_profile_controller.dart';
import 'package:hotel_pms/app/modules/user_management/tables/sources/employee_session_table_source.dart';
import 'package:hotel_pms/app/modules/user_management/tables/table/table_constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import '../../../reports/view/hand_over_form_view.dart';

class EmployeeSessionsTableView extends GetView<UserProfileController> {
  EmployeeSessionsTableView({Key? key}) : super(key: key);

  final EmployeeSessionsSource source = EmployeeSessionsSource();
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
                      BigText(text: "Employee Sessions"),
                      tableHeader(
                          onRefreshEntries: controller.loadUserActivity,
                          title: "Employee Sessions",
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
                              columnName: EmployeeSessionTrackerTableColumn.dateCreated,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: 'Date Created'
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeSessionTrackerTableColumn.dateEnded,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: SmallText(
                                      text: 'Date Ended'
                                          .toUpperCase()))),
                          GridColumn(
                              columnName: EmployeeSessionTrackerTableColumn.status,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'STATUS'))),
                          GridColumn(
                              columnName: EmployeeSessionTrackerTableColumn.sessionId,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const SmallText(text: 'id'))),

                        ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
