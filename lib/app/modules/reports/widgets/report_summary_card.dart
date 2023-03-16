
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../core/resourses/color_manager.dart';
import '../../../../widgets/buttons/icon_text_button.dart';

Widget buildReportSummaryCard(String title,int number,double percentage){

  // return Container(
  //   //width: const Size.fromWidth(250).width,
  //     decoration: BoxDecoration(
  //       color: ColorsManager.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: ColorsManager.grey.withOpacity(0.7),width: 1.5),
  //       boxShadow: const [
  //         BoxShadow(
  //             color: ColorsManager.white,
  //             offset: Offset(0.0, 3.0),
  //             blurStyle: BlurStyle.normal
  //         ),
  //         BoxShadow(color: ColorsManager.grey1,
  //             offset: Offset(0.0, 2.0), blurStyle: BlurStyle.normal),
  //         BoxShadow(color: ColorsManager.grey2,
  //             offset: Offset(0.0, 1.0), blurStyle: BlurStyle.normal)
  //       ],
  //     ),
  //   child: Padding(
  //     padding: const EdgeInsets.only(left: 20,top: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SmallText(text: title,color: ColorsManager.darkGrey.withOpacity(0.9),),
  //         Row(
  //           children: [
  //             BigText(text: number.toString()),
  //             IconTextButton(
  //               buttonWidth: 100,
  //               iconColor: percentage.isNegative ? ColorsManager.error : ColorsManager.success,textColor: percentage.isNegative ? ColorsManager.error : ColorsManager.success,
  //               buttonLabel: '$percentage%', icon: percentage.isNegative ? Icons.arrow_downward : Icons.arrow_upward, onPressed: (){},
  //             ),
  //
  //           ],
  //         )
  //       ],
  //     ),
  //   ),
  // );
  return Card(
    elevation: 1.0,
    //width: const Size.fromWidth(250).width,
    child: Padding(
      padding: const EdgeInsets.only(left: 20,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(text: title,color: ColorsManager.darkGrey.withOpacity(0.9),),
          Row(
            children: [
              BigText(text: number.toString()),
              IconTextButton(
                buttonWidth: 100,
                iconColor: percentage.isNegative ? ColorsManager.error : ColorsManager.success,textColor: percentage.isNegative ? ColorsManager.error : ColorsManager.success,
                buttonLabel: '$percentage%', icon: percentage.isNegative ? Icons.arrow_downward : Icons.arrow_upward, onPressed: (){},
              ),

            ],
          )
        ],
      ),
    ),
  );
}
