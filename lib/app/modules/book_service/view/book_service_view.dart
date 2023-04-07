import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/book_service/controller/book_service_controller.dart';
import 'package:hotel_pms/app/modules/book_service/widgtes/booking_calender.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../../../../widgets/buttons/myElevatedButton.dart';
import 'book_service_form.dart';

class BookServiceView extends GetView<BookServiceController> {
  const BookServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookServiceController>(
      init: BookServiceController(),
        builder: (controller)=>Scaffold(
          appBar: buildGlobalAppBar(context,appBarTitle:'Book Services',onBackButton: (){
            Get.back();
          }),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            children: [

              /// Title and Book Service buttons
              SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BigText(text: 'Book Services'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MyElevatedButton(
                          onPressed: (){
                            buildDialog(
                                context,
                                 'ROOM',
                                 BookServiceForm(isRoom: 1,),
                              width: 700,
                              height: 600,
                              alignment: Alignment.center
                            );
                            },
                          text: 'Book Room',
                      ),
                      SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
                      MyElevatedButton(
                          onPressed: (){buildDialog(
                              context,
                              'CONFERENCE',
                              BookServiceForm(isRoom: 0,),
                              width: 700,
                              height: 600,
                              alignment: Alignment.center
                          );},
                        text: 'Book Conference Room',
                      ),
                    ],
                  ),
                ],
              ),
            ),
              thinDivider(),

              /// View Booked Services
               SizedBox(
                  width: const Size.fromWidth(1280).width,
                  height: 600,
                  child: const BookingsCalender())
          ],
        ),
      ),

    ));
  }
}
