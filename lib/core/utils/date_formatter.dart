


import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';

import '../values/localization/local_keys.dart';

import '../../widgets/icons/app_icon.dart';
import '../../widgets/text/big_text.dart';
import '../../widgets/text/small_text.dart';
import 'package:get/get.dart';

bool isTimeDifferenceLessOrEqualTo(DateTime firstDate,DateTime secondDate, int differenceValueInHours){
  int timeDifferenceInHours = firstDate.difference(secondDate).inHours;
  return timeDifferenceInHours <= differenceValueInHours ? true : false;
}

bool isDateDifferenceLessOrEqualTo(DateTime firstDate,DateTime secondDate, int differenceValueInDays){
  int daysDifferenceInDays = firstDate.difference(secondDate).inDays;
  return daysDifferenceInDays <= differenceValueInDays ? true : false;
}

String extractDate(DateTime? date,{String? dateFromString}){
  DateTime workingDate = date ?? DateTime.parse(dateFromString ?? DateTime.now().toIso8601String());
  if(date==null && dateFromString==null) return '-';
  return "${workingDate.day}-${workingDate.month}-${workingDate.year}";
}
String extractTime(DateTime time,{bool is_file_name = false}){
  String minute = time.minute <= 0 ? '0${time.minute}' : time.minute.toString();
  return is_file_name? "${time.hour}_${minute}_${time.second}_${time.millisecond}_${time.microsecond}"
        :"${time.hour}:$minute";
}

String resetTimeInDateTime(DateTime date,{bool toEndOfDay = false,bool toGivenHM =false,int hour =10,int minute=0}){
  if(toEndOfDay){
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 0, 0).toIso8601String();
  }else if(toGivenHM){
    return DateTime(date.year, date.month, date.day, hour, minute, 0, 0, 0).toIso8601String();
  }
  return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0).toIso8601String();
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

String getMonthName(int month){
  switch (month){
    case 1 : return 'January';
    case 2 : return 'February';
    case 3 : return 'March';
    case 4 : return 'April';
    case 5 : return 'May';
    case 6 : return 'June';
    case 7 : return 'July';
    case 8 : return 'August';
    case 9 : return 'September';
    case 10 : return 'October';
    case 11 : return 'November';
    case 12 : return 'December';
    default : return 'none';

  }
}

class CheckOutDateBox extends StatefulWidget {
  final DateTime? selectedDate;
  final TextEditingController liveNights;


  CheckOutDateBox({Key? key, required this.selectedDate,required this.liveNights}) : super(key: key);

  @override
  State<CheckOutDateBox> createState() => _CheckOutDateBoxState();
}

class _CheckOutDateBoxState extends State<CheckOutDateBox> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: const Size.fromWidth(200).width,
      height: 43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black,width: 2.0),
          color: ColorsManager.flutterGrey
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.selectedDate == null ? const SmallText(text: "Check Out Date") :
            BigText(text: extractDate(
                 widget.selectedDate!.add(
                Duration(days: stringToInt(widget.liveNights.value.text))
              )
            )
            ),
            SmallText(text: LocalKeys.kCheckout.tr)
            //const AppIcon(icon: Icons.calendar_month,useBackground: true,)
          ],
        ),
      ),
    );
  }
}
