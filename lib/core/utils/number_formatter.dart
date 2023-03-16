import 'package:flutter/widgets.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:intl/intl.dart';
String formatNumber(String number){
  var formatter = NumberFormat('#,###,###');
  bool isNumber = RegExp(r'^[0-9]+$').hasMatch(number);
  return isNumber ? formatter.format(int.parse(number)).toString(): number;
}