import 'package:flutter/material.dart';

import 'package:hotel_pms/widgets/images/display_image.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../../../../core/values/assets.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import 'package:get/get.dart';
import '../../controller/laundry_form_controller.dart';

class DisplayStoredLaundry extends GetView<LaundryFormController> {
  const DisplayStoredLaundry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaundryFormController>(
      init: LaundryFormController(),
        builder: (controller)=>Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Obx(() => SmallText(text: 'Returning ${controller.returnedLaundryBuffer.value.length}'),),
        SizedBox(
          height: const Size.fromHeight(300).height,
          child: Obx(() => controller.receivedLaundryView.value.isNotEmpty
              ? GridView(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            children: List<Widget>.generate(
                controller.receivedLaundryView.value.length, (index) {
              return Obx(() => Card(
                      color: controller.returnedLaundryBuffer.value.contains(controller.receivedLaundryView.value[index]) ? ColorsManager.success : ColorsManager.white,
                  child: InkWell(
                    onTap: (){
                      controller.bufferReturnedLaundryItems(controller.receivedLaundryView.value[index]);
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(
                              text: controller.receivedLaundryView
                                  .value[index].grandTotal
                                  .toString()),
                          SmallText(
                              text:
                              '${LocalKeys.kLaundry.tr}  : ${controller.receivedLaundryView.value[index].transactionNotes.toString().split(':')[1]}'),
                          SmallText(
                              text:
                              '${LocalKeys.kQuantity.tr} : ${controller.receivedLaundryView.value[index].transactionNotes.toString().split(':')[0]}'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
              : displayImage(asset: Assets.kEmptyLaundry)),
        ),
      ],
    ));
  }
}
// class DisplayStoredLaundry extends GetView<LaundryFormController> {
//   const DisplayStoredLaundry({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LaundryFormController>(builder: (controller)=>Expanded(
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         child: Obx(()=>DataTable(
//             border: TableBorder.all(
//                 color: ColorsManager.darkGrey,
//                 width: 1,
//                 style: BorderStyle.solid,
//                 borderRadius: BorderRadius.circular(10)
//             ),
//             columns:   [
//               DataColumn(label: SmallText(text: LocalKeys.kDescription.tr,)),
//               DataColumn(label: SmallText(text: LocalKeys.kUnit.tr,)),
//               DataColumn(label: SmallText(text: LocalKeys.kValue.tr,)),
//               DataColumn(label: SmallText(text: LocalKeys.kReturn.tr)),
//             ],
//             rows:List<DataRow>.generate(controller.receivedLaundryViewCount.value, (index) {
//               return DataRow(
//                   cells: [
//
//                     DataCell(
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: BigText(text: controller.receivedLaundryView.value[index].transactionNotes!,),
//                       ),
//                     ),
//                     DataCell(
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: BigText(text: controller.receivedLaundryView.value[index].grandTotal.toString(),),
//                       ),
//                     ),
//                     DataCell(
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: BigText(text: controller.receivedLaundryView.value[index].outstandingBalance.toString(),),
//                       ),
//                     ),
//                     DataCell(
//                         InkWell(
//                             onTap: (){
//                                   controller.returningLaundry.value ?
//                                   controller.bufferReturnedLaundryItems(controller.receivedLaundryView.value[index]) :
//                                   controller.bufferNewStoredLaundry();
//                             },
//                             child: const AppIcon(icon: Icons.arrow_forward_outlined,)
//                         )
//                     ),
//                   ]
//               );
//             })
//
//         )),
//       ),
//     ));
//   }
// }

