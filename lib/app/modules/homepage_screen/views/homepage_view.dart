import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/check_in_screen/view/check_in_form_view.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/app/modules/widgtes/global_navigation_buttons.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/core/values/localization/localization_controller.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import '../../../../core/resourses/color_manager.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../../../../widgets/cards/dashboard_card.dart';
import '../../../../widgets/text/big_text.dart';
import '../../guest_dashboard/views/guest_dashboard_view.dart';
import '../controller/homepage_controller.dart';


List<String> homePageTabs = [LocalKeys.kRooms, LocalKeys.kSales];

class HomePageView extends GetView<HomepageController> {
  HomePageView({Key? key}) : super(key: key);

  final ButtonStyle style =
  ElevatedButton.styleFrom(backgroundColor: ColorsManager.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
  );

  AuthController authController = Get.put(AuthController(),permanent: true);
  LocalizationController langController = Get.put(LocalizationController(),permanent: true);
  //HomepageController homepageController = Get.put(HomepageController(),permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
        builder: (controller)=>Scaffold(
        appBar: buildGlobalAppBar(context),
        body: Obx(() => Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: const Size.fromHeight(AppSize.size14).height,),

          buildGlobalNavigationButtons(context,onTitleTap: controller.onInit),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: thinDivider(),
          ),

          /// Rooms
          /// Displays A grid of Rooms with Different Colors to indicate Status
          Expanded(
            child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                ),
                children: List<Widget>.generate(controller.roomDataCount.value, (index) {
                  return Builder(builder: (BuildContext context){
                    return InkWell(
                      onTap:(){
                        controller.selectedRoom(controller.roomData.value[index]);
                        if(controller.selectedRoomData.value.roomStatus!.description == LocalKeys.kOccupied){
                          Get.to(popGesture: true,opaque: true,()=> const GuestDashboardView());

                        }else{
                          Get.to(()=> CheckInView());
                        }
                      },
                      child: controller.roomData.value.isEmpty ? const Center(child: BigText(text: "Didn't load RoomData",),):

                      Obx(()=> ConstrainedBox(
                        constraints: BoxConstraints.loose(const Size.fromWidth(200)),
                        child: DashboardCard(
                          title: controller.roomData.value[index].roomNumber.toString(),
                          subtitle:  controller.roomData.value[index].roomStatus!.description!.tr,
                          backgroundColor:  AppConstants.roomStatusColor[controller.roomData.value[index].roomStatus!.code]!,
                          onTap:(){},
                        ),
                      )),
                    );
                  });
                })
            ),
          ),
        ],
      )),
    ));
  }
}


