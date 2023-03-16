import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import 'package:get/get.dart';

import '../../controller/room_details_controller.dart';



class UserActivityTableView extends GetView<RoomDetailsController> {
   const UserActivityTableView({Key? key}) : super(key: key);
  //RoomDetailsController con = Get.put(RoomDetailsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomDetailsController>(
      init: RoomDetailsController(),
        builder: (controller)=>SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(()=>DataTable(
          border: TableBorder.all(
              color: ColorsManager.darkGrey,
              width: 1,
              style: BorderStyle.solid,
              borderRadius: BorderRadius.circular(10)
          ),

          columns:  [
            DataColumn(
              label: Expanded(
                child: SmallText(text: "${LocalKeys.kDate.tr}-${LocalKeys.kTime.tr}"),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: SmallText(text: LocalKeys.kEmployee.tr),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: SmallText(text: LocalKeys.kAction.tr),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: SmallText(text: LocalKeys.kDescription.tr),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: SmallText(text: LocalKeys.kUnit.tr),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: SmallText(text: LocalKeys.kValue.tr),
              ),
            ),

          ],

          rows: List<DataRow>.generate(controller.userActivityCount.value, (index) {
            String date = extractDate(DateTime.parse(controller.userActivity.value[index].dateTime!));
            String time = "${DateTime.parse(controller.userActivity.value[index].dateTime!).hour}:${DateTime.parse(controller.userActivity.value[index].dateTime!).minute}";
            return DataRow(
                cells: [
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: "$date,$time"),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: controller.userActivity.value[index].employeeFullName ?? 'Null'),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: controller.userActivity.value[index].activityStatus ?? ""),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: controller.userActivity.value[index].description!),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: controller.userActivity.value[index].unit!),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BigText(text: controller.userActivity.value[index].activityValue.toString()),
                    ),
                  )
                ]
            );

          }),
        )),
      ),
    ));
  }
}
