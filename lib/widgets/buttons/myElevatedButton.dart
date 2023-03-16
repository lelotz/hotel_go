import 'package:flutter/material.dart';

import '../../core/resourses/color_manager.dart';
import '../../core/values/localization/local_keys.dart';
import '../text/small_text.dart';

class MyElevatedButton extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Function onPressed;

  MyElevatedButton({Key? key,
    required this.text,
    required this.onPressed,
    this.textColor=ColorsManager.grey1,
    this.backgroundColor = ColorsManager.primary,

  }) : super(key: key);

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed:(){ widget.onPressed();},
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )
        ),

        child: SmallText(text: widget.text,color: widget.textColor,))
    ;
  }
}
