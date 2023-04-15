import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

class CardButton extends StatelessWidget {
  CardButton({Key? key, required this.onPressed, required this.text, this.textColor=ColorsManager.darkGrey, this.isSmallText=true}) : super(key: key);
  final Function onPressed;
  final String text;
  final Color textColor;
  final bool isSmallText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: ()async{
          await onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isSmallText ? SmallText(text: text,color: textColor,): BigText(text: text,color: textColor),
        )
      ),
    );
  }
}
