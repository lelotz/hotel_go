import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/room_data_screen/controller/laundry_form_controller.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import 'package:get/get.dart';

import '../../controller/room_details_controller.dart';


class DisplayStoredLaundry extends GetView<LaundryFormController> {
  const DisplayStoredLaundry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaundryFormController>(builder: (controller)=>Expanded(
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
            rows:List<DataRow>.generate(controller.receivedLaundryViewCount.value, (index) {
              return DataRow(
                  cells: [

                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedLaundryView.value[index].transactionNotes!,),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedLaundryView.value[index].grandTotal.toString(),),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: controller.receivedLaundryView.value[index].outstandingBalance.toString(),),
                      ),
                    ),
                    DataCell(
                        InkWell(
                            onTap: (){
                                  controller.returningLaundry.value ?
                                  controller.bufferReturnedLaundryItems(controller.receivedLaundryView.value[index]) :
                                  controller.bufferNewStoredLaundry();
                            },
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

