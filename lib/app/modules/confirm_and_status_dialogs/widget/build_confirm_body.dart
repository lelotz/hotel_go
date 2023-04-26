import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';


Widget buildConfirmMessageBody(String message,String separator){
  List<String> messageList = message.split('\n');

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: List<Widget>.generate(messageList.length, (index) {

        return Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: messageList[index].split(separator).length == 2 ? [
              SmallText(text: messageList[index].split(separator)[0]),
              SmallText(text: messageList[index].split(separator)[1]),
            ] : [],
          ),
        );
      }),
    ),
  );
}
