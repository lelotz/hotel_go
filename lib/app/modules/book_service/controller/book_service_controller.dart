import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  Rx<List<ServiceBooking>> bookedServices = Rx<List<ServiceBooking>>([]);
  Rx<bool> isLoadingEvents = false.obs;

  @override
  onInit()async{
    super.onInit();
    await loadBookedServices();
  }

  updateUI(){
    selectedDayEvents.refresh();
    selectedDayEventsCount.refresh();
    bookedServices.refresh();
  }

  Future<void> getSelectedDayEvents(DateTime bookingStartDate)async{
    selectedDayEvents.value.clear();
    await ServiceBookingRepository().getServiceBookingByBookingStartDate(bookingStartDate.toIso8601String()).then((value) {
      selectedDayEvents.value = {extractDate(bookingStartDate):ServiceBooking().fromJsonList(value ?? [])};
      selectedDayEventsCount.value = value?.length ?? 0;
      //logger.i({'eventsLoaded': value});

      updateUI();
    });
  }

  Future<void> deleteBooking(ServiceBooking booking)async{
    await ServiceBookingRepository().deleteServiceBooking(booking.toJson());
    selectedDayEvents.value.remove(booking);
    updateUI();
  }

  Future<void> cancelBooking(ServiceBooking booking)async{
    booking.bookingStatus = 'CANCELED';
    await ServiceBookingRepository().updateServiceBooking(booking.toJson());

  }

  Future<void> invoiceBooking(ServiceBooking booking)async{

  }

  Future<void> completeBooking(ServiceBooking booking)async{
    booking.bookingStatus = 'COMPLETE';
    await ServiceBookingRepository().updateServiceBooking(booking.toJson());
  }

  List<Map<String,Function>> getOptions(){
    return [{'Invoice': invoiceBooking},{'Complete': completeBooking},{'Delete': deleteBooking}];
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

  Future<void> loadBookedServices()async{
    isLoadingEvents.value = true;
    bookedServices.value.clear();
    ServiceBookingRepository().getServiceBookingByStatus('ACTIVE').then((value) async{
      if(value !=null && value.isNotEmpty){
        bookedServices.value = ServiceBooking().fromJsonList(value);
      }
    });
    updateUI();
    isLoadingEvents.value = false;
  }

  List<ServiceBooking> getEvents(DateTime day){
    List<ServiceBooking> events = [];
    for(ServiceBooking event in bookedServices.value){
      if(extractDate(DateTime.tryParse(event.serviceStartDate!)) == extractDate(day)){
        events.add(event);
      }
    }
    return events;
  }

  List<ServiceBooking> getEventsForDay(DateTime day){
    return selectedDayEvents.value[extractDate(day)] ?? [];
  }


}
