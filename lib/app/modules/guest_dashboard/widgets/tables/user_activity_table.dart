import 'package:flutter/material.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import 'package:get/get.dart';

import '../../controller/guest_dashboard_controller.dart';



class UserActivityTableView extends GetView<GuestDashboardController> {
   const UserActivityTableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestDashboardController>(
      init: GuestDashboardController(),
        builder: (controller)=> SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(()=> controller.fetchingUserActivity.value ? SizedBox() : Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              // border: TableBorder(
              //     color: ColorsManager.darkGrey,
              //     width: 1,
              //     style: BorderStyle.solid,
              //     borderRadius: BorderRadius.circular(10)
              // ),

              columns:  [
                DataColumn(
                  label: Expanded(
                    child: BigText(text: "${LocalKeys.kDate.tr}-${LocalKeys.kTime.tr}"),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: BigText(text: LocalKeys.kEmployee.tr),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: BigText(text: LocalKeys.kAction.tr),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: BigText(text: LocalKeys.kDescription.tr),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: BigText(text: LocalKeys.kUnit.tr),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: BigText(text: LocalKeys.kValue.tr),
                  ),
                ),

              ],

              rows: List<DataRow>.generate(controller.userActivity.value.length, (index) {
                String date = extractDate(DateTime.parse(controller.userActivity.value[index].dateTime!));
                String time = "${DateTime.parse(controller.userActivity.value[index].dateTime!).hour}:${DateTime.parse(controller.userActivity.value[index].dateTime!).minute}";
                return DataRow(
                    cells: [
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: "$date,$time"),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: controller.userActivity.value[index].employeeFullName ?? 'Null'),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: controller.userActivity.value[index].activityStatus ?? ""),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: controller.userActivity.value[index].description!.tr),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: controller.userActivity.value[index].unit!.tr),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallText(text: controller.userActivity.value[index].activityValue.toString()),
                        ),
                      )
                    ]
                );

              }),
            ),
          ),
        )),
      ),
    ));
  }
}
