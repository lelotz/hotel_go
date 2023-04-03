import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/resourses/size_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import 'dialog_forms.dart';
import '../tables/user_activity_table.dart';

class SaleSummary extends StatefulWidget {


  SaleSummary({Key? key}) : super(key: key);

  @override
  State<SaleSummary> createState() => _SaleSummaryState();
}

class _SaleSummaryState extends State<SaleSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        /// Dialog Form Header
        /// Includes Room Number, Status, Guest Name, and Form Title
        dialogFormHeader(LocalKeys.kSaleDetails.tr),
        //const Expanded(child: UserActivityTable()),
        Padding(
          padding:  const EdgeInsets.all(AppPadding.padding8),
          child: BigText(text: LocalKeys.kActivity.tr.capitalize!,size: AppSize.size32,),
        ),
         Expanded(
            child: SizedBox(
                child: UserActivityTableView()
            )
        )
      ],
    );
  }

}