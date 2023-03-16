import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/buttons/my_outlined_button.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

Widget bookedServiceCalenderWidget(ServiceBooking booking){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: const Size.fromWidth(20).width,),
      Expanded(
        flex: 1,
        child: MyOutlinedButton(
          text: booking.bookingStatus.toString(), onClick: (){},
          backgroundColor: getBookingStatusColor(booking.bookingStatus.toString()),
        ),
      ),
      SizedBox(width: const Size.fromWidth(20).width,),
      Expanded(
        flex: 1,
        child: MyOutlinedButton(
          text: '${booking.bookingType}${booking.isRoom == 1? ' : ${booking.roomNumber}' : ''}', onClick: (){},
        backgroundColor: ColorsManager.primary,
      ),),
      SizedBox(width: const Size.fromWidth(20).width,),
      Expanded(
        flex: 2,
          child: BigText(text: booking.name.toString())),
      SizedBox(width: const Size.fromWidth(20).width,),
      Expanded(
        flex: 3,
        child: Row(
          children: [
            BigText(text: extractDate(DateTime.parse(booking.serviceStartDate ?? ''))),
            const BigText(text: ' - '),
            BigText(text: extractDate(DateTime.parse(booking.serviceEndEndDate ?? '')))

          ],
        ),
      )


    ],
  );
}

Color getBookingStatusColor(String status){
  switch (status){
    case 'ACTIVE': return ColorsManager.success;
    default : return ColorsManager.primaryAccent;
  }

}