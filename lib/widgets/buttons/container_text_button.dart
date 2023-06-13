import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../text/small_text.dart';

class ContainerTextButton extends StatefulWidget {
  final String text;
  final double textSize;
  final double paddingValue;
  final Color textColor;
  final Color backgroundColor;
  final bool useBorder;
  final bool isClickable;
  final Color borderColor;
  final VoidCallback onClick;
  final bool hasIcon;
  final IconData icon;
  final double? buttonWidth;
  ContainerTextButton({
    Key? key,
    this.textColor = ColorsManager.lightGrey,
    this.backgroundColor = ColorsManager.white,
    this.borderColor = ColorsManager.white,
    this.textSize = AppSize.size14,
    this.useBorder = false,
    this.isClickable = false,
    this.paddingValue = AppPadding.padding12,
    this.hasIcon = false,
    this.icon = Icons.hourglass_empty,
    this.buttonWidth = 150,
    required this.onClick,
    required this.text,

  }) : super(key: key);

  @override
  State<ContainerTextButton> createState() => _ContainerTextButtonState();
}

class _ContainerTextButtonState extends State<ContainerTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(
        onPressed: widget.onClick,
        child: Padding(
          padding: EdgeInsets.all(widget.paddingValue),
          child: Center(child: SmallText(text:widget.text,color: widget.textColor,size: widget.textSize,)),
        ),
      ),
    );
  }
}

