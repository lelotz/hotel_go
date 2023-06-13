import 'package:flutter/material.dart';


class AppIconButton extends StatefulWidget {

  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color backgroundColor;
  final Function onPressed;
  // bool pressed;



  AppIconButton({Key? key,
    // this.pressed=false,
    this.iconSize=16,
    this.iconColor=const Color(0xFF756d54),
    this.backgroundColor = const Color(0xFFfcf4e4),
    required this.onPressed,
    required this.icon
  }) : super(key: key);
  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {






  @override
   Widget build(BuildContext context) {
    return Container(
      width: widget.iconSize,
      height: widget.iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.iconSize),
        color: widget.backgroundColor
      ),
      child: IconButton(
          onPressed: (){
            widget.onPressed();
          },
          icon: Icon(widget.icon),
        iconSize: widget.iconSize,
        color: widget.iconColor,
        splashRadius: 3,
        splashColor: Colors.green,

          )
    );
  }
}
