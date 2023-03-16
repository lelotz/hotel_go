import 'package:flutter/material.dart';
import '../../core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../text/small_text.dart';



class DynamicIconTextButton extends StatefulWidget {
  String text;
  IconData icon;
  double iconSize;
  double textSize;
  Color iconColor;
  Color textColor;
  VoidCallback callback;

  DynamicIconTextButton({
    Key? key,
    this.textColor = ColorsManager.darkGrey,
    this.iconColor = ColorsManager.darkGrey,
    this.textSize = AppSize.size16,
    this.iconSize = AppSize.size24,
    required this.callback,
    required this.icon,
    required this.text,

  }) : super(key: key);

  @override
  State<DynamicIconTextButton> createState() => _DynamicIconTextButtonState();
}

class _DynamicIconTextButtonState extends State<DynamicIconTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      radius: AppBorderRadius.radius16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.iconColor,
          ),
          const SizedBox(width: 5,),
          SmallText(text: widget.text,color: widget.textColor,size: widget.textSize,)
        ],
      ),
    );
  }
}
