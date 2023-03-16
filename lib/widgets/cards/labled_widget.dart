

import 'package:flutter/cupertino.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';

Widget buildLabeledWidget(String label,Widget widget){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: ColorsManager.darkGrey,width: 2)
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: label),
          widget
        ],
      ),
    ),
  );
}