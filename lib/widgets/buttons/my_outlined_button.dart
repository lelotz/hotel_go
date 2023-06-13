

import 'package:flutter/material.dart';
import '../../core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../text/small_text.dart';

class MyOutlinedButton extends StatefulWidget {
  final Function onClick;
  final String text;
  final double width;
  final double height;
  final double padding;
  final double borderRadius;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  Color currentTextColor;
  final bool autoSize;
  MyOutlinedButton({Key? key,
    required this.text,
    required this.onClick,
    this.width = 120,
    this.height = 45,
    this.textColor = ColorsManager.white,
    this.currentTextColor = ColorsManager.white,
    this.backgroundColor =  ColorsManager.primary,
    this.borderColor = ColorsManager.white,
    this.padding = AppPadding.padding8,
    this.borderRadius = AppPadding.padding8,
    this.autoSize = false,
  }) : super(key: key);

  @override
  State<MyOutlinedButton> createState() => _MyOutlinedButtonState();
}

class _MyOutlinedButtonState extends State<MyOutlinedButton> {

  @override
  void initState() {
    setState(() {
      widget.currentTextColor = widget.textColor;
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return OutlinedButton(
      onHover: (isHovering){
        setState(() {
          widget.currentTextColor = isHovering ? ColorsManager.primaryAccent : widget.textColor;
        });

      },
      style: OutlinedButton.styleFrom(
        elevation: 3,
        backgroundColor: widget.backgroundColor,
        side: BorderSide(
          color: widget.borderColor,
          width: 1.3

        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),

        ),
      ),onPressed: (){
        widget.onClick();
        },
      child: SmallText(text: widget.text,color: widget.currentTextColor,),
    );
  }
}
