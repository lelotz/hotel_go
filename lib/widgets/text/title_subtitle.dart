import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import 'big_text.dart';


class LabeledText extends StatelessWidget {
  final String title;
  final String subtitle;
  final double titleSize;
  final double subtitleSize;
  final Color titleColor;
  final Color subtitleColor;
  final double dividerHeight;
  final IconData? iconTitle;
  final bool isNumber;
  final bool isRow;
  final Function? iconButtonFunction;
  final Color hoverColor;
  final bool switchProperties;
  const LabeledText({
    Key? key,
    this.isNumber = false,
    this.titleSize = AppSize.size20,
    this.subtitleSize = AppSize.size24,
    this.subtitleColor = ColorsManager.darkGrey,
    this.titleColor = ColorsManager.darkGrey,
    this.hoverColor = ColorsManager.primaryAccent,
    this.dividerHeight = AppSize.size12,
    this.isRow = false,
    this.iconTitle,
    this.iconButtonFunction,
    this.switchProperties = false,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: Size.fromHeight(isRow? 0 : 20).height),
      child: isRow ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconTitle == null ? SmallText(text: title,color: switchProperties ? subtitleColor : titleColor,
                size: switchProperties ? subtitleSize : titleSize):
            InkWell(
              onTap: (){
                if(iconButtonFunction != null) iconButtonFunction!();
              },
              hoverColor: hoverColor,
              borderRadius: BorderRadius.circular(4),
              child: Icon(iconTitle,color: titleColor,size: titleSize),
            ),
            SizedBox(width: Size.fromWidth(dividerHeight).width-5,),
            BigText(text: subtitle,color: switchProperties ?  titleColor:subtitleColor,
              size: switchProperties ? subtitleSize : titleSize,isNumber: isNumber,)
        ],
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            iconTitle == null ? SmallText(text: title,color: switchProperties ? subtitleColor : titleColor,
                size: switchProperties ? subtitleSize : titleSize):
            InkWell(
              onTap: (){
                if(iconButtonFunction != null) iconButtonFunction!();
              },
              hoverColor: hoverColor,
              borderRadius: BorderRadius.circular(4),
              child: Icon(iconTitle,color: titleColor,size: titleSize),
            ),
            SizedBox(height: Size.fromHeight(dividerHeight).height),
            BigText(text: subtitle,color: switchProperties ?  titleColor:subtitleColor,
              size: switchProperties ? subtitleSize : titleSize,isNumber: isNumber,)
        ],
      )
    );
  }
}
