


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';

import 'dim_logic.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/text/big_text.dart';
import '../../widgets/text/small_text.dart';

String extractDate(DateTime? date,{String? dateFromString}){
  if(dateFromString!=null){
    date = DateTime.parse(dateFromString);
  }
  final String onlyDate = "${date!.day}-${date.month}-${date.year}";

  return onlyDate;
}
String extractTime(DateTime time){
  return "${time.hour}:${time.hour}";
}

String resetTimeInDateTime(DateTime date,{bool toEndOfDay = false}){
  return toEndOfDay ? '${DateTime(date.year, date.month, date.day, 23, 59, 59, 0, 0).toIso8601String()}Z':
                      '${DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0).toIso8601String()}Z';
}

Widget selectDate(BuildContext context,DateTime? selectedDate,Function(DateTime? selectedDate) showDatePicker){
  return Container(
    width: const Size.fromWidth(200).width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
        color: Colors.white
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: selectedDate == null ? const SmallText(text: "Select Date") : BigText(text: extractDate(selectedDate)),
        ),
        InkWell(
            onTap: (){
              showDatePicker(selectedDate);
            },
            child: const AppIcon(icon: Icons.calendar_month,useBackground: true,)
        )
      ],
    ),
  );
}

class CheckOutDateBox extends StatefulWidget {
  DateTime? selectedDate;
  TextEditingController liveNights;


  CheckOutDateBox({Key? key, required this.selectedDate,required this.liveNights}) : super(key: key);

  @override
  State<CheckOutDateBox> createState() => _CheckOutDateBoxState();
}

class _CheckOutDateBoxState extends State<CheckOutDateBox> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: const Size.fromWidth(200).width,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child:
            widget.selectedDate == null ? const SmallText(text: "Check Out Date") :
            BigText(text: extractDate(
                 widget.selectedDate!.add(
                Duration(days: stringToInt(widget.liveNights.value.text))
              )
            )
          ),
        ),
          //const AppIcon(icon: Icons.calendar_month,useBackground: true,)
        ],
      ),
    );
  }
}