import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/core/values/app_constants.dart';

import '../../../../../widgets/text/big_text.dart';
import '../../../../../widgets/text/small_text.dart';
import 'package:get/get.dart';


class GuestActionsDropdown extends StatefulWidget {
  String initialItem;
  String selectedValue;
  bool enabled;
  String disabledHint;
  List<String> menuItems;
  Function callback;
  double borderRadius;
  int currentIndex;
  String header;


  GuestActionsDropdown(
      {
        Key? key,
    this.borderRadius = AppBorderRadius.radius12,
    this.selectedValue = "noneLabel",
    this.currentIndex = 0,
    this.header = "noneLabel",
    this.enabled = true,
    this.disabledHint = "Actions",
        required this.menuItems,
    required this.callback,
    required this.initialItem,

  }) : super(key: key);

  @override
  State<GuestActionsDropdown> createState() => _GuestActionsDropdownState();
}

class _GuestActionsDropdownState extends State<GuestActionsDropdown> {
  bool isExpanded = false;
  String? currentItem;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     return Container(
       decoration: BoxDecoration(
         border: Border.all(color: ColorsManager.darkGrey),
         borderRadius: BorderRadius.circular(widget.borderRadius)
       ),
       child: DropdownButton(

        isExpanded: isExpanded,
        disabledHint:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: BigText(text: widget.disabledHint),
        ),

        value: currentItem,
        hint: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmallText(text: widget.initialItem,fontWeight: FontWeight.bold,),
        ),
        elevation: 1,
        underline: const Text(''),
        onChanged: (newValue){
              setState(() {
                currentItem = newValue!;
              });
        },
        borderRadius: BorderRadius.circular(widget.borderRadius),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: widget.menuItems.map((String menuItem){
          return  DropdownMenuItem(
            onTap: () async {
              await widget.callback(context: context, formName: AppConstants.formNamesMap[menuItem]);
              setState((){
                widget.callback(context: context, formName: AppConstants.formNamesMap[menuItem]);
                //Navigator.of(context).pop();
              });
            },
            alignment: Alignment.center,
            value: menuItem,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(child: BigText(text:menuItem)),
            ),
          );
        }).toList(),
    ),
     );
  }
}


