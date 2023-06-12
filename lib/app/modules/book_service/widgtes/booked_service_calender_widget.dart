
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/app/modules/book_service/controller/book_service_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/widgets/buttons/my_outlined_button.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:get/get.dart';

Widget bookedServiceCalenderWidget(ServiceBooking booking,List<Map<String,Function>> options){
  const double spacer = 10;
  return ExpandablePanel(
    header: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width:  const Size.fromWidth(spacer).width,),
        Expanded(
          flex: 1,
          child: MyOutlinedButton(
            text: booking.bookingStatus.toString(), onClick: (){},
            backgroundColor: getBookingStatusColor(booking.bookingStatus.toString()),
          ),
        ),
        SizedBox(width: const Size.fromWidth(spacer).width,),
        Expanded(
          flex: 2,
          child: SmallText(text: '${booking.bookingType}${booking.isRoom == 1? ' : ${booking.roomNumber}' : ''}'),),
        SizedBox(width: const Size.fromWidth(spacer).width,),
        Expanded(
            flex: 2,
            child: BigText(text: booking.name.toString())),



      ],
    ),
      collapsed: SizedBox(),
      expanded: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: const Size.fromWidth(spacer).width,),
      Expanded(
        flex: 3,
        child: Row(
          children: [
            BigText(text: extractDate(DateTime.parse(booking.serviceStartDate ?? DateTime.now().toIso8601String()))),
            const BigText(text: ' - '),
            BigText(text: extractDate(DateTime.parse(booking.serviceEndEndDate ?? DateTime.now().toIso8601String())))

          ],
        ),
      ),

      SizedBox(width: const Size.fromWidth(spacer).width,),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            SmallText(text: 'Package'),
            const BigText(text: ' : '),
            BigText(text: booking.invoiceNo?? '-')

          ],
        ),
      ),
      SizedBox(width: const Size.fromWidth(spacer).width,),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            SmallText(text: 'Value'),
            const BigText(text: ' : '),
            BigText(text: booking.serviceValue.toString())

          ],
        ),
      ),
      SizedBox(width: const Size.fromWidth(spacer).width,),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            SmallText(text: 'Advance'),
            const BigText(text: ' : '),
            BigText(text: booking.advancePayment.toString())

          ],
        ),
      ),
      SizedBox(width: const Size.fromWidth(spacer).width,),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            SmallText(text: 'Balance'),
            const BigText(text: ' : '),
            BigText(text: (booking.serviceValue ?? 0 - stringToInt(booking.advancePayment)).toString())

          ],
        ),
      ),

      PopupMenuButton(itemBuilder: (context){
        return List<PopupMenuEntry>.generate(options.length, (index) {
          return PopupMenuItem(
              onTap: ()async{
                await options[index].values.toList()[0](booking);
                await Get.find<BookServiceController>().loadBookedServices();
              },
              child: SmallText(text: '${options[index].keys.toList()[0]}',)
          );
        });
      })


    ],
  ));
}

Color getBookingStatusColor(String status){
  switch (status){
    case 'ACTIVE': return ColorsManager.success;
    default : return ColorsManager.primaryAccent;
  }

}