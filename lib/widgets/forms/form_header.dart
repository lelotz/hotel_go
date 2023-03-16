import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/resourses/color_manager.dart';
import '../text/big_text.dart';

Widget buildFormHeader(String formName,{bool enableCancelButton = true}){
  return /// Heading
    Container(
      color: ColorsManager.primaryAccent.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            BigText(text: formName,size: 18,),
            //SizedBox(width: const Size.fromWidth(170).width,),
            enableCancelButton ? InkWell(onTap: (){
              Navigator.of(Get.overlayContext!).pop();},child: const Icon(Icons.close)):
                const SizedBox()
          ],
        ),
      ),
    );
}