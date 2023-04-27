
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../../core/resourses/color_manager.dart';
import '../../../../../core/resourses/size_manager.dart';
import '../../../../../widgets/buttons/decorated_text_button.dart';
import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/title_subtitle.dart';
import '../../controller/user_profile_controller.dart';

class UserProfileSummaryView extends GetView<UserProfileController> {
  const UserProfileSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(builder: (controller)=>Card(
      child: Padding(
        padding: const EdgeInsets.all(82),
        child: Column(

          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmallText(text: controller.employeeKeyMetricTitle.value),
            ),
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
                  width:  Size.fromWidth(150).width,
                  child: Center(child: Obx(() => BigText(text: controller.adminUser.value.roomsSold.toString(),size: AppSize.size56,))),
                ),
                Obx(() => DecoratedTextButton(
                    buttonLabel: controller.adminUser.value.status.toString(),
                    backgroundColor: controller.adminUser.value.status.toString() == 'ENABLED' ? ColorsManager.success : ColorsManager.red,
                    textColor: Colors.white,
                    onPressed: (){}
                ),)
              ],
            ),

            /// Guest Name
            Obx(()=>LabeledText(title: controller.adminUser.value.position!, subtitle: controller.adminUser.value.fullName.toString())),
            /// Phone Number
            Obx(()=>SmallText(text: controller.adminUser.value.phone.toString()
            )),

          ],
        ),
      ),
    ));
  }
}
