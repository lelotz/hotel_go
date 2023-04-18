
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

class MyCheckBox extends StatelessWidget {
  MyCheckBox({Key? key,required this.title,required this.value, required this.onChanged,this.stackTitle=false}) : super(key: key);
  final bool value;
  final Function(bool) onChanged;
  final bool stackTitle;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Flex(

      direction: stackTitle ? Axis.vertical : Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmallText(text: title),
        ),
        Checkbox(
          value: value, onChanged: (state){
          onChanged(state ?? false);
      }),]
    );
  }
}
