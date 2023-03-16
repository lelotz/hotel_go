import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';

//
// Widget successAlert(String title,String subtitle,{BuildContext? context}){
//   return _buildButton(
//     onTap: ()async {
//       await CoolAlert.show(
//         context: context!,
//         type: CoolAlertType.success,
//         text: title,
//         autoCloseDuration: const Duration(seconds: 2),
//       );
//     },
//     text: subtitle,
//     color: Colors.green,
//   );
// }
//
// Widget errorAlert(String title,String errorDescription,String subtitle,{bool? loopAnimation = false,BuildContext? context}){
//   return _buildButton(
//     onTap: () async {
//       await CoolAlert.show(
//         context: context!,
//         type: CoolAlertType.error,
//         title: title,
//         text: errorDescription,
//         loopAnimation: loopAnimation!,
//       );
//     },
//     text: subtitle,
//     color: Colors.red,
//   );
// }

Future<dynamic> confirmAlert(String title,String subtitle, {String? confirmText = LocalKeys.kYes,String? cancelText = LocalKeys.kNo}){
  return CoolAlert.show(
    context: Get.context!,
    type: CoolAlertType.confirm,
    text: title,
    confirmBtnText: confirmText!,
    cancelBtnText: cancelText!,
    confirmBtnColor: Colors.green,
  );
}

Widget _buildButton({required Widget popUp, required String text, Color? color}) {
  // bool readyToClose = false;
  // Future.delayed(const Duration(seconds: 2),(){
  //   readyToClose = true;
  // });
  // if(readyToClose) Navigator.of(Get.overlayContext!).pop();
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: MaterialButton(
      color: color,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: (){},
      child: popUp,
    ),
  );
}


