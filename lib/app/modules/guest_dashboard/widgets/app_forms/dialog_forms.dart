import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/mydividers.dart';

import '../../../../../core/resourses/size_manager.dart';
import '../../../../../core/values/localization/local_keys.dart';
import '../../../../../widgets/text/big_text.dart';
import '../cards/room_and_guest_card.dart';
import 'collect_payment_form.dart';
import 'laundry_form.dart';
import 'package_storage_form.dart';
import 'room_service_form.dart';
import 'sale_summary_form.dart';




Widget fetchDialogWidget({required String dialogName}){
  //print("[INFO] Required Dialog: $dialogName");
  switch(dialogName){
    case LocalKeys.kRoomService : {
      //print("[FETCHED] $dialogName Widget");
      return RoomServiceForm();
    }

    case LocalKeys.kCollectPayment : {
      //print("[FETCHED] $dialogName Widget");
      return CollectPaymentForm();
    }
    case LocalKeys.kLaundry : {
      //print("[FETCHED] $dialogName Widget");
      return LaundryForm();
    }
    case LocalKeys.kStorePackage:{
      //print("[FETCHED] $dialogName Widget");
      return StorePackageForm();
    }
    case "Sale Summary":{
      return SaleSummary();
    }
    default: {
      //print("[FETCHED] $dialogName Widget");
      return Center(child: BigText(text: "Undefined Dialog Name: $dialogName"));
    }
  }
}


void actionsDialogForms({required BuildContext context, required String formName,double height = 500})async
{
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return  Dialog(
          elevation: 10,
          child:  Container(
              height:  Size.fromHeight(height).height,
              width: const Size.fromWidth(550).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.radius16),
              ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: formName == "Sale Summary" ? SaleSummary():
              fetchDialogWidget(dialogName: formName),
            ) ,
          )
        );
      },
    ).whenComplete(() {
      //print("[INFO] Called $formName Dialog\n");
  });
}

Widget dialogFormHeader(String title){
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: BigText(text: title),
      ),
      /// Display Room Number, Status, and, Guest Name
      // thinDivider(),
      // const RoomAndGuestCard(),
      // thinDivider(),
    ],
  );
}








