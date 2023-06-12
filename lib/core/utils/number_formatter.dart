import 'package:intl/intl.dart';
String formatNumber(String number){
  var formatter = NumberFormat('###,###,###');
  bool isNumber = RegExp(r'^[0-9]+$').hasMatch(number);
  return isNumber ? formatter.format(int.parse(number)).toString(): number;
}