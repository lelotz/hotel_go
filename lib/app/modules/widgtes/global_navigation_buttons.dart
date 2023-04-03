import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/reports/view/reports_view.dart';
import 'package:hotel_pms/app/modules/sandbox/syncfusion_table_example.dart';
import 'package:hotel_pms/app/modules/user_management/views/user_management_view.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/illustrations/illustrations_example.dart';
import '../../../core/resourses/color_manager.dart';
import '../../../core/resourses/size_manager.dart';
import '../../../core/values/localization/local_keys.dart';
import '../../../widgets/tables/paged_table_example.dart';
import '../../../widgets/text/big_text.dart';
import '../../../widgets/text/small_text.dart';
import '../book_service/view/book_service_view.dart';
import '../sales_module/view/sales_view.dart';
import '../book_service/widgtes/booking_calender.dart';
import 'form_selector_pop_up.dart';




Widget buildGlobalNavigationButtons(BuildContext context,{String title = LocalKeys.kRooms,Function? onTitleTap}){
  final ButtonStyle style =
  ElevatedButton.styleFrom(backgroundColor: ColorsManager.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
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
                onPressed: (){Get.to(()=> ReportsView());},
                child:  SmallText(text: LocalKeys.kReports.tr,color: ColorsManager.grey1,)
            ),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=>const BookServiceView());},
                child: SmallText(text: LocalKeys.kBookService.tr,color: ColorsManager.grey1,)),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=> const UserManagementView());},
                child: SmallText(text: LocalKeys.kUserManagement.tr,color: ColorsManager.grey1,)),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            const FormSelector(),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=> const SyncFusionExample());},
                child: const SmallText(text: "Exportable Table",color: ColorsManager.grey1,)),
            SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
            ElevatedButton(
                style:style,
                onPressed: (){Get.to(()=> PagedDataExample());},
                child: const SmallText(text: "Paged Data Example",color: ColorsManager.grey1,)),

          ],
        ),
      ],
    ),
  );
}