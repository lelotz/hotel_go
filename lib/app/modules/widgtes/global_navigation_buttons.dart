import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/app/modules/reports/view/report_selector.dart';
import 'package:hotel_pms/app/modules/user_management/views/user_management_view.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/widgets/dropdown_menu/ai_dropdown.dart';
import '../../../core/resourses/color_manager.dart';
import '../../../core/resourses/size_manager.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/values/localization/local_keys.dart';
import '../../../widgets/text/big_text.dart';
import '../../../widgets/text/small_text.dart';
import '../book_service/view/book_service_view.dart';
import '../sales_module/view/sales_view.dart';
import 'form_selector_pop_up.dart';




Widget buildGlobalNavigationButtons(BuildContext context,{String title = LocalKeys.kRooms,Function? onTitleTap}){
  final ButtonStyle style =
  ElevatedButton.styleFrom(backgroundColor: ColorsManager.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
  AuthController authController = Get.find<AuthController>();
  return   Padding(
    padding: EdgeInsets.symmetric(horizontal:  const Size.fromWidth(AppSize.size12).width),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap:(){
            if(onTitleTap != null) onTitleTap();
          },
            child: BigText(text: title.tr, size: AppSize.size32,)
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(transition: Transition.noTransition,duration: const Duration(milliseconds: 500), ()=> SalesView());},
                child:  SmallText(text: LocalKeys.kSales.tr,color: ColorsManager.grey1,)),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=> BookServiceView());},
                child: SmallText(text: LocalKeys.kBookService.tr,color: ColorsManager.grey1,)),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            authController.adminUser.value.position == AppConstants.userRoles[1] ? ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=> const UserManagementView());},
                child: SmallText(text: LocalKeys.kUserManagement.tr,color: ColorsManager.grey1,)): const SizedBox(),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            const FormSelector(),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ReportSelector(),
            SizedBox(width: const Size.fromWidth(36).width,),



          ],
        ),
      ],
    ),
  );
}