import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/confirm_and_status_dialogs/widget/build_confirm_body.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/buttons/card_button.dart';
import 'package:hotel_pms/widgets/forms/form_header.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({Key? key,required this.separator,required this.onConfirmed,required this.confirmText,this.confirmTitle='Confirm'}) : super(key: key);
  final Function onConfirmed;
  final String confirmText;
  final String? confirmTitle;
  final String separator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Header and Body
        Column(
          children: [
            // dialogFormHeader(confirmTitle!),
            buildFormHeader(confirmTitle!,enableCancelButton: false),
            SizedBox(height: Size.fromHeight(5).height,),
            buildConfirmMessageBody(confirmText,separator),
            // SmallText(text: confirmText,maxLines: 10,)
          ],
        ),
        /// Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CardButton(onPressed: (){
              Navigator.pop(Get.overlayContext!);
            }, text: 'No'),
            CardButton(
              backgroundColor: ColorsManager.primaryAccent,
                textColor: ColorsManager.grey1,
                onPressed: ()async{await onConfirmed();}, text: 'Yes'),

          ],
        )
      ],
    );
  }
}
