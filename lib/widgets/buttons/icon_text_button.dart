import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../icons/app_icon.dart';
import '../text/small_text.dart';


class IconTextButton extends StatefulWidget {

  final  String buttonLabel;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;
  double iconSize;
  final bool useDivider;
  final double buttonHeight;
  final double buttonWidth;
  final Function onPressed;


  IconTextButton({
    Key? key,
    required this.buttonLabel,
    required this.icon,
    required this.onPressed,
    this.buttonHeight = 30,
    this.buttonWidth = 250,
    this.iconSize = 16,
    this.iconColor = ColorsManager.darkGrey,
    this.backgroundColor = ColorsManager.white,
    this.useDivider = true,
    this.textColor = ColorsManager.lightGrey


  }) : super(key: key);

  @override
  State<IconTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  bool isTapped = false;

  void onPressed(){
    setState(() {

      if(!isTapped){
        widget.iconSize -= 5;
      }
      isTapped = !isTapped;


    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: (){widget.onPressed();},
        borderRadius:  BorderRadius.circular(AppBorderRadius.radius16),
        child: Center(
          child: Container(
            height: widget.buttonHeight,
            width: Size.fromWidth(widget.buttonWidth).width,
            decoration:BoxDecoration(
            color: widget.backgroundColor,
              borderRadius:  BorderRadius.circular(15),
          ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(indent: 20),
                AppIcon(
                  icon: widget.icon,
                  iconColor: widget.iconColor,
                  iconSize: isTapped ? widget.iconSize += 5 : widget.iconSize,
                  backgroungColor: widget.backgroundColor,
                  size: 30,
                ),
                const Divider(indent: 10),
                SmallText(text: widget.buttonLabel,color: widget.textColor),
                Divider(height: widget.useDivider ? 3.0 : 0,thickness:widget.useDivider ? 2.0 : 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
