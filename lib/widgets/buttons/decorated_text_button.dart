import 'package:flutter/material.dart';
import '../../core/resourses/size_manager.dart';
import '../text/big_text.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';



class DecoratedTextButton extends StatefulWidget {
  final String buttonLabel;
  final Color textColor;
  final Color backgroundColor;
  final bool useDivider;
  final double buttonWidth;
  final double paddingValue;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final VoidCallback onPressed;

  DecoratedTextButton({
    Key? key,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor = ColorsManager.primary,
    this.useDivider = true,
    this.textColor = ColorsManager.darkGrey,
    this.paddingValue = 10,
    this.bottomMargin = 0,
    this.topMargin = 0,
    this.leftMargin = 0,
    this.rightMargin = 0,
    this.buttonWidth = AppSize.size150,
  }) : super(key: key);

  @override
  State<DecoratedTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<DecoratedTextButton> {
  bool isTapped = false;

  void onPressed() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      borderRadius: BorderRadius.circular(AppBorderRadius.radius16),
      hoverColor: ColorsManager.primary,
      child: Container(
        margin: EdgeInsets.only(
            bottom: widget.bottomMargin,
            top: widget.topMargin,
            left: widget.topMargin,
            right: widget.rightMargin),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppBorderRadius.radius16),
              bottomRight: Radius.circular(AppBorderRadius.radius16)),
        ),
        height: const Size.fromHeight(30).height,
        width: Size.fromWidth(widget.buttonWidth).width,
        child: Center(
          child: BigText(text: widget.buttonLabel, color: widget.textColor),
        ),
      ),
    );
  }
}
