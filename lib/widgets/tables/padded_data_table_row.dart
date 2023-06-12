
import 'package:flutter/material.dart';

DataCell paddedDataCell({required Widget text,double vPadding = 8,double hPadding = 2}){
  return DataCell(Padding(
    padding: EdgeInsets.symmetric(vertical: vPadding,horizontal: hPadding), child: text));
}