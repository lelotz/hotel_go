import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import '../../core/resourses/size_manager.dart';
import '../text/big_text.dart';
import '../text/small_text.dart';
import 'package:get/get.dart';
class GeneralDropdownMenu extends StatefulWidget {
  final String initialItem;
  String selectedValue;
  bool enabled;
  bool userBorder;
  String disabledHint;
  List<String> menuItems;
  Function callback;
  double borderRadius;
  int currentIndex;
  String header;
  Color? hintTextColor;
  Color? backgroundColor;
  Color? borderColor;
  bool resetButton;
  String? currentItem;

  GeneralDropdownMenu(
      {Key? key,
        this.borderRadius = AppSize.size4,
        this.selectedValue = "noneLabel",
        this.currentIndex = 0,
        this.header = "noneLabel",
        this.enabled = true,
        this.disabledHint = "Actions",
        this.userBorder = true,
        this.hintTextColor = ColorsManager.darkGrey,
        this.resetButton = false,
        this.backgroundColor = ColorsManager.flutterGrey,
        this.currentItem,
        this.borderColor = ColorsManager.darkGrey,
        required this.menuItems,
        required this.callback,
        required this.initialItem,
      }) : super(key: key);

  @override
  State<GeneralDropdownMenu> createState() => _GeneralDropdownMenuState();
}

class _GeneralDropdownMenuState extends State<GeneralDropdownMenu> {


  bool isExpanded = false;
  bool? refreshFlag;

  int index = 0;
  String selectedItem = "Actions";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  BoxDecoration getDecoration(bool useBorder){
    return useBorder?  BoxDecoration(
      color: widget.backgroundColor,
        border: Border.all(color: widget.borderColor!,width: 2),
        borderRadius: BorderRadius.circular(widget.borderRadius)
    ): BoxDecoration(color: widget.backgroundColor,);
  }
  /// Initial Value
  /// To allow a user to make changes to related dropdown menus the
  /// bool [refreshFlag]
  /// is not initialized to allow the expression in [value] to use the
  /// bool [dependentRefreshFlag] to determine whether [value] should be
  /// null or have the value of [currentItem]
  ///
  /// When [value] is null the dropdown menu displays the provided [disabledHintText]
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecoration(widget.userBorder),
      child: DropdownButton(
        isExpanded: isExpanded,
        disabledHint:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: BigText(text: widget.disabledHint),
        ),

        value: widget.currentItem,
        hint: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmallText(text: widget.initialItem,fontWeight: FontWeight.w700,color: widget.hintTextColor,),
        ),
        elevation: 1,
        underline: const Text(''),
        onChanged: (newValue){
          widget.callback(newValue.toString());
          setState(() {
            widget.currentItem = newValue.toString();
          });
        },
        borderRadius: BorderRadius.circular(widget.borderRadius),
        icon: const Icon(Icons.keyboard_arrow_down),


        items: widget.menuItems.map((String menuItem){
          return  DropdownMenuItem(

            onTap: (){
              setState(() {
                widget.currentItem = menuItem.toString();
              });
            },
            alignment: Alignment.topLeft,
            value:menuItem,
            // child: Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Center(child: BigText(text: menuItem.tr.toString())),
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
              child: BigText(text: menuItem.tr.toString()),
            ),
          );
        }).toList(),
      ),
    );
  }
}


