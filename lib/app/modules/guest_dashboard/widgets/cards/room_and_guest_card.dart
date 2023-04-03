

import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import '../../../../../core/values/app_constants.dart';
import 'package:flutter/material.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/buttons/decorated_text_button.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/title_subtitle.dart';
import 'package:get/get.dart';
import '../../controller/guest_dashboard_controller.dart';

/// Room Number, Status and Guest Name
class RoomAndGuestCard extends GetView<GuestDashboardController> {

  final bool isRow;
  final double roomCardWidth;
  const RoomAndGuestCard({Key? key, this.isRow = true,this.roomCardWidth = AppSize.size150}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    GetBuilder<GuestDashboardController>(
      init: GuestDashboardController(),
        builder: (controller)=>

      isRow ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Room Number
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorsManager.grey1,
                    border: Border.all(color: ColorsManager.darkGrey),
                    borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.radius16))
                ),
                height: const Size.fromHeight(160).height,
                width:  Size.fromWidth(roomCardWidth).width,
                child: Center(child: BigText(text: controller.selectedRoom.value.roomNumber.toString(),size: AppSize.size56,)),
              ),
              DecoratedTextButton(
                  buttonLabel: controller.selectedRoom.value.roomStatus!.description!,
                  backgroundColor: AppConstants.roomStatusColor[controller.selectedRoom.value.roomStatus!.code]!,
                  textColor: Colors.white,
                  onPressed: (){}
              ),
            ],
          ),

          /// Guest Name
          Obx(()=>LabeledText(title: LocalKeys.kGuest.tr, subtitle: controller.clientUser.value.fullName!)),

          /// Today's Date

        ],

      ) :
      Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                // decoration: BoxDecoration(
                //     color: Colors.white24,
                //     //border: Border.all(color: ColorsManager.darkGrey),
                //     //borderRadius: const BorderRadius.all(Radius.circular(15))
                // ),
                height: const Size.fromHeight(160).height,
                // width: Size.fromHeight(roomCardWidth).width,
                child: Center(child: BigText(text: controller.selectedRoom.value.roomNumber.toString(),size: 60,)),
              ),

              DecoratedTextButton(
                  buttonLabel: controller.selectedRoom.value.roomStatus!.description!,
                  backgroundColor: AppConstants.roomStatusColor[controller.selectedRoom.value.roomStatus!.code]!,
                  textColor: Colors.white,
                  onPressed: (){}
              ),
            ],
          ),

          /// Guest Name
          Obx(()=>LabeledText(title: LocalKeys.kGuest.tr, subtitle: controller.clientUser.value.fullName ?? 'Loading')),
        ],
      )
    );
  }
}
