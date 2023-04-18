import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/book_service/controller/book_service_controller.dart';
import 'package:hotel_pms/app/modules/book_service/widgtes/booking_calender.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../../../../widgets/buttons/myElevatedButton.dart';
import '../widgtes/book_conference_form.dart';
import '../widgtes/book_room_form.dart';
import 'book_service_form.dart';

class BookServiceView extends GetView<BookServiceController> {
  BookServiceView({Key? key}) : super(key: key);

  // final BookServiceController bookServiceController = Get.put(BookServiceController(),permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookServiceController>(
      init: BookServiceController(),
        builder: (controller)=>Scaffold(
          appBar: buildGlobalAppBar(context,appBarTitle:'Book Services',onBackButton: (){
            Get.back();
            Get.delete<BookServiceController>();
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
                      Obx(() => controller.isLoadingEvents.value ? loadingAnimation(actionStatement: '') : MyElevatedButton(
                        onPressed: ()async{
                          await controller.loadBookedServices();
                        },
                        text: 'Refresh',
                      ),),
                      SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
                      MyElevatedButton(
                          onPressed: (){
                            Get.to(()=>BookRoomForm());
                            },
                          text: 'Book Room',
                      ),
                      SizedBox(width: const Size.fromWidth(AppSize.size4).width,),
                      MyElevatedButton(
                          onPressed: (){
                            Get.to(()=>BookConferenceForm());
                            },
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
                  width: const Size.fromWidth(1300).width,
                  height: 600,
                  child: const BookingsCalender())
          ],
        ),
      ),

    ));
  }
}
