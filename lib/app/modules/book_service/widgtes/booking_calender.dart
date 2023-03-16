import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/app/modules/book_service/controller/book_service_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'booked_service_calender_widget.dart';


class BookingsCalender extends GetView<BookServiceController> {
  const BookingsCalender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookServiceController>(
      init: BookServiceController(),
        builder: (controller)=>Column(
        children: [
          TableCalendar<ServiceBooking>(
            firstDay: DateTime.now().add(const Duration(days: -300)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: controller.focusDate.value,
            calendarFormat: controller.calendarFormat.value,
            eventLoader: controller.getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: controller.shouldMarkDate,
            onDaySelected: controller.onDaySelected,
            onFormatChanged: controller.onFormatChanged,
            onPageChanged: (focusedDay) {
              controller.focusDate.value = focusedDay;
              controller.focusDate.refresh();
            },
          ),
          ElevatedButton(
            onPressed: controller.selectedDayEvents.value.clear,
            child: const Text('Clear selection')
          ),

          const SizedBox(height: 8.0),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.selectedDayEventsCount.value,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: bookedServiceCalenderWidget(controller.selectedDayEvents.value[extractDate(controller.currentDate.value)]?[index] ?? ServiceBooking()),
                  ),
                );
              },
            )),
          ),
      ],
    ));
  }
}
