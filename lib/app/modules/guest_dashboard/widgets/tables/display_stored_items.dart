import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import 'package:get/get.dart';

import '../../controller/package_form_controller.dart';
import '../../controller/guest_dashboard_controller.dart';


class DisplayStoredItems extends GetView<PackageFormController> {
  const DisplayStoredItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageFormController>(
      init: PackageFormController(),
        builder: (controller)=>Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Obx(()=>DataTable(
            border: TableBorder.all(
                color: ColorsManager.darkGrey,
                width: 1,
                style: BorderStyle.solid,
                borderRadius: BorderRadius.circular(10)
            ),
            columns:   [
              DataColumn(label: SmallText(text: LocalKeys.kDescription.tr,)),
              DataColumn(label: SmallText(text: LocalKeys.kUnit.tr,)),
              DataColumn(label: SmallText(text: LocalKeys.kValue.tr,)),
              DataColumn(label: SmallText(text: LocalKeys.kReturn.tr)),
            ],
            rows:List<DataRow>.generate(controller.receivedPackagesViewCount.value, (index) {
              return DataRow(
                  cells: [

                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedPackagesView.value[index].description!,),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedPackagesView.value[index].unit!,),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedPackagesView.value[index].activityValue.toString(),),
                      ),
                    ),
                    DataCell(
                        InkWell(
                            onTap: ()=> controller.bufferReturnedPackage(controller.receivedPackagesView.value[index]),
                            child: const AppIcon(icon: Icons.arrow_forward_outlined,)
                        )
                    ),

                  ]
              );
            })

        )),
      ),
    ));
  }
}

