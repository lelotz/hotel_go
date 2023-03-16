import 'dart:collection';

import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/logs/logger_instance.dart';

class BookServiceController extends GetxController{

  Logger logger = AppLogger.instance.logger;

  Rx<Map<String,List<ServiceBooking>>> selectedDayEvents = Rx<Map<String,List<ServiceBooking>>>({});
  Rx<DateTime> focusDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime> currentDate = Rx<DateTime>(DateTime.now());
  Rx<CalendarFormat> calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
  Rx<int> selectedDayEventsCount = 0.obs;

  updateUI(){
    selectedDayEvents.refresh();
    selectedDayEventsCount.refresh();
    //currentDate.refresh();
    //focusDate.refresh();
  }

  Future<void> getSelectedDayEvents(DateTime bookingStartDate)async{
    await ServiceBookingRepository().getServiceBookingByBookingStartDate(bookingStartDate.toIso8601String()).then((value) {
      selectedDayEvents.value = {extractDate(bookingStartDate):ServiceBooking().fromJsonList(value ?? [])};
      selectedDayEventsCount.value = value?.length ?? 0;
      //logger.i({'eventsLoaded': value});

      updateUI();
    });
  }


  Future<void> onDaySelected(DateTime selectedDay, DateTime focusedDay)async{
    currentDate.value = selectedDay;
    focusDate.value = selectedDay;
    focusDate.refresh();
    selectedDayEvents.value.clear();
    logger.i({'Before Refresh':'','focusDate': focusDate.value.toString()});
    currentDate.refresh();
    logger.i({'After Refresh':'','focusDate': focusDate.value.toString()});
    await getSelectedDayEvents(selectedDay);
    update();
  }

  bool shouldMarkDate(DateTime day){


    if(currentDate.value==day){
      focusDate.value = day;
      //update();
      return true;
    }
    //update();
    return false;
  }

  void onFormatChanged(CalendarFormat calenderFormat){
      if (calendarFormat.value != calenderFormat) {
        calendarFormat.value = calenderFormat;
        calendarFormat.refresh();
        update();
      }

  }

  List<ServiceBooking> getEventsForDay(DateTime day){
    return selectedDayEvents.value[extractDate(day)] ?? [];
  }


}
