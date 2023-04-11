
import 'package:flutter/material.dart';

import '../text/small_text.dart';

Widget displayImage({required String asset,double height=200,BoxFit fit = BoxFit.contain,double borderRadius=200,String statement=''}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      statement != '' ?  SmallText(text: statement) : SizedBox(),
      SizedBox(height: Size.fromHeight(statement != '' ?  20 : 0).height,),
      Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(image: AssetImage(asset),fit: fit)
        ),
      ),
    ],
  );
}