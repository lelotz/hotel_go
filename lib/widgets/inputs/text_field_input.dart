import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../core/resourses/size_manager.dart';
import '../icons/app_icon.dart';



class TextFieldInput extends StatefulWidget {
  TextEditingController textEditingController;
  final bool isPass;
  final bool useBorder;
  final bool useIcon;
  final String title;
  final String hintText;
  final IconData icon;
  final TextInputType textInputType;
  final Color? hintTextColor;
  final Function? validation;
  final double inputFieldWidth;
  final double inputFieldHeight;
  final double borderRadius;
  final MainAxisAlignment mainAxisAlignment;

  final int maxLines;
  Function? onChanged;

   TextFieldInput({ Key? key,
    required this.textEditingController,
     this.isPass=false,
     this.useBorder=true,
     this.useIcon=false,
     this.icon=Icons.hourglass_empty,
     this.onChanged,
     this.title="noneLabel",
     this.maxLines = 1,
     this.hintTextColor = ColorsManager.darkGrey,
     this.validation,
     this.inputFieldHeight = 70,
     this.
     inputFieldWidth = 150,
     this.mainAxisAlignment = MainAxisAlignment.start,
     this.borderRadius = AppBorderRadius.radius4,
     required this.hintText,
     this.textInputType = TextInputType.text,
  }) : super(key: key);



  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {


    final inputBorder = widget.useBorder ? OutlineInputBorder(
        borderSide: Divider.createBorderSide(context,width: 2,color: ColorsManager.darkGrey),
      borderRadius: BorderRadius.circular(widget.borderRadius)
    ): const UnderlineInputBorder();

    final focusedBorder = widget.useBorder ? OutlineInputBorder(
        borderSide: Divider.createBorderSide(context,color: ColorsManager.success,width: 2),
        borderRadius: BorderRadius.circular(widget.borderRadius)
    ): const UnderlineInputBorder();

    return TextFormField(
      validator: (value){
        return widget.validation != null ? widget.validation!(value) : null;
      },
      maxLines: widget.maxLines,
      controller: widget.textEditingController,
      onChanged: (value){
          setState(() {
            if(widget.onChanged != null){
              if(value != ""){widget.onChanged!();}
            }
          });
      },
      decoration: InputDecoration(
        icon: widget.useIcon ? AppIcon(icon: widget.icon,iconSize: AppSize.size24,): null,
        border: inputBorder,
        focusedBorder: focusedBorder,
        enabledBorder: inputBorder,
        filled: false,
        contentPadding: const EdgeInsets.all(8),
        hintText: widget.hintText,
        hoverColor: widget.hintTextColor,
        label: SmallText(text: widget.hintText,color:widget.hintTextColor,fontWeight: FontWeight.w700,),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass,
    );
  }
}