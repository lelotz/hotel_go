import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/icons/app_icon.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../../../../core/values/assets.dart';
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
        builder: (controller)=>SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallText(text: 'Returning Packages'),
                  Card(child: Padding(
                    padding: EdgeInsets.all(8),
                      child: SmallText(text: '${controller.returnedPackagesBufferCount}'))),
                ],
              ),
              Obx(()=>SizedBox(
                height: const Size.fromHeight(320).height,
                child: controller.storedPackagesView.value.isNotEmpty ? GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                  ),
                  children: List<Widget>.generate(controller.storedPackagesView.value.length, (index) {
                    return Builder(builder: (BuildContext context){
                      return InkWell(
                        onTap: (){
                          controller.bufferReturnedPackage(controller.storedPackagesView.value[index]);
                        },
                        child: Obx(() => Card(
                          color: controller.returnedPackagesBuffer.value.contains(controller.storedPackagesView.value[index]) ? ColorsManager.success : ColorsManager.white,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(text: "Item  : ${controller.storedPackagesView.value[index].description}",),
                                BigText(text: "Unit : ${controller.storedPackagesView.value[index].unit}",),
                                BigText(text: "Value : ${controller.storedPackagesView.value[index].value}",)
                              ],
                            ),
                          ),
                        )),
                      );
                    });
                  }),
                ): Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(Assets.kEmptyBox),fit: BoxFit.contain)
                      ),
                    ),
                    Center(child: SmallText(text: 'No Packages Stored',),),
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}

// Widget x(){
//   return DataTable(
//       border: TableBorder.all(
//           color: ColorsManager.darkGrey,
//           width: 1,
//           style: BorderStyle.solid,
//           borderRadius: BorderRadius.circular(10)
//       ),
//       columns:   [
//         DataColumn(label: SmallText(text: LocalKeys.kDescription.tr,)),
//         DataColumn(label: SmallText(text: LocalKeys.kUnit.tr,)),
//         DataColumn(label: SmallText(text: LocalKeys.kValue.tr,)),
//         DataColumn(label: SmallText(text: LocalKeys.kReturn.tr)),
//       ],
//       rows:List<DataRow>.generate(controller.receivedPackagesViewCount.value, (index) {
//         return DataRow(
//             cells: [
//
//               DataCell(
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BigText(text: controller.receivedPackagesView.value[index].description!,),
//                 ),
//               ),
//               DataCell(
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BigText(text: controller.receivedPackagesView.value[index].unit!,),
//                 ),
//               ),
//               DataCell(
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BigText(text: controller.receivedPackagesView.value[index].activityValue.toString(),),
//                 ),
//               ),
//               DataCell(
//                   InkWell(
//                       onTap: ()=> controller.bufferReturnedPackage(controller.receivedPackagesView.value[index]),
//                       child: const AppIcon(icon: Icons.arrow_forward_outlined,)
//                   )
//               ),
//
//             ]
//         );
//       })
//
//   );
// }