import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/guest_dashboard_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/widgets/tables/user_activity_table.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/buttons/card_button.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../homepage_screen/controller/homepage_controller.dart';
import '../../../homepage_screen/views/homepage_view.dart';
import '../../controller/clear_controllers.dart';


class HouseKeepingRoomStatus extends GetView<GuestDashboardController> {
  const HouseKeepingRoomStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestDashboardController>(
      init: GuestDashboardController(),
        builder: (controller)=>Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => Row(
              mainAxisAlignment: controller.housekeeperAssigned.value == false ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
              children: [
                Obx(() => controller.housekeeperAssigned.value == false ? GeneralDropdownMenu(
                    menuItems: controller.houseKeepingStaffNames.value,
                    callback: (String selected)async{
                      controller.selectHouseKeeper(selected);
                      await controller.assignHouseKeeperRoomToClean();
                    },
                    initialItem: 'Housekeeper'
                ) : SizedBox()
                ),
                Obx(() => SmallText(size: 18,text: 'Housekeeper aliechaguliwa : ${controller.selectedHouseKeeperName}'),
                ),
              ],
            ),),

            Row(
              children: [
                SizedBox(width: Size.fromWidth(10).width,),
                Obx(() => controller.isSettingRoomToAvailable.value && controller.selectedHouseKeeperName.value == '' ?
                SmallText(text: 'Chagua Housekeeper',color: ColorsManager.error,) : SizedBox())
              ],
            ),
            UserActivityTableView(),
            CardButton(

                onPressed: ()async{
                  controller.isSettingRoomToAvailable.value = true;
                  controller.isSettingRoomToAvailable.refresh();
                  if(controller.selectedHouseKeeperName!=''){
                    await controller.setRoomAsAvailable();
                    await Get.find<HomepageController>().loadRoomData();
                    await deleteRoomControllers();
                    Get.to(()=> HomePageView());
                    // Get.back();
                  }
                }, text: 'Tayari Kuuzwa'
            ),
          ],
        ),
      ),
    ));
  }
}
