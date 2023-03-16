

import 'package:flutter/cupertino.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

Widget buildFilterBoxItem(String itemLabel,Widget itemWidget,{double width = 350}){
  return SizedBox(
    width:  itemLabel == "" ? Size.fromWidth(width).width * .80 : Size.fromWidth(width).width,
    height: const Size.fromHeight(100).height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        itemLabel == "" ? const SizedBox():SizedBox(
          width: Size.fromWidth(width).width * .28,
            child: SmallText(text: itemLabel,color: ColorsManager.white,)
        ),
        SizedBox(
            width: Size.fromWidth(width).width * .72,
            child: itemWidget),
      ],
    ),
  );

}