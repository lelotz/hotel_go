
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/conference_booking_details_repo.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';

import '../../../../core/logs/logger_instance.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../data/local_storage/repository/service_booking_repo.dart';
import '../../../data/models_n/conference_booking_details.dart';
class BookServiceFormController extends GetxController with GlobalCalculations{
  Logger logger = AppLogger.instance.logger;

  /// EMPLOYEE ID
  AuthController authController = Get.find<AuthController>();

  /// Calculated VALUES
  /// IS ROOM, BOOKING TYPE
  ///
  /// ROOM STATUS
  String roomStatus = "BOOKED";
  /// ID
  Rx<String> bookServiceId = Rx<String>(const Uuid().v1());

  Rx<String> bookingExpiryDate = Rx<String>(extractDate(DateTime.now()));

  Rx<String> bookingButtonText = Rx<String>('Create Booking');

  Rx<bool> allDatesSelected = false.obs;

  Rx<int> selectedDatesCount = 0.obs;
  Rx<bool> bookingInitiated = false.obs;
  Rx<bool> bookingCreated = false.obs;
  Rx<Color> bookingButtonColors = Rx<Color>(ColorsManager.primary);
  Rx<List<Map<String,dynamic>>> checkedConferenceDates = Rx<List<Map<String,dynamic>>>([]);
  /// Inputs

  /// Date-picker ->Book Event StartDate
  Rx<DateTime> bookingServiceStartDate= Rx<DateTime>(DateTime.now());

  Rx<DateTime> focusDate= Rx<DateTime>(DateTime.now());

  Rx<List<Map<String,dynamic>>> selectedConferenceDates = Rx<List<Map<String,dynamic>>>([]);

  /// Date-picker -> Book Event EndDate
  Rx<DateTime> bookingServiceEndDate= Rx<DateTime>(DateTime.now());
  /// NAME
  TextEditingController nameController = TextEditingController();
  /// PHONE
  TextEditingController phoneController = TextEditingController();
  /// PEOPLE COUNT
  TextEditingController peopleCountController = TextEditingController();
  /// ROOM NUMBER
  TextEditingController roomNumberController = TextEditingController();
  /// INVOICE NO.
  TextEditingController invoiceNumberController = TextEditingController();
  /// ADVANCE PAYMENT
  TextEditingController advancePaymentController = TextEditingController();
  /// PAY METHOD
  Rx<String> payMethod = Rx<String>('CASH');
  /// SERVICE COST
  TextEditingController serviceValueController = TextEditingController();

  @override
  onInit(){
    nameController.text = mockNames[random(0,mockNames.length)];
    peopleCountController.text = "0";
    advancePaymentController.text = "0";
    phoneController.text = "0755${random(223344, 999999)}";
    roomNumberController.text = "105";
    calculateServiceCost(1);
    updateBookingExpiryDate();
    super.onInit();
  }

  bool get checkedDate {
    if(allDatesSelected.value) return true;
    return false;
  }

  updateUI(){
    focusDate.refresh();
    selectedConferenceDates.refresh();
    payMethod.refresh();
    bookingButtonColors.refresh();
    bookingButtonText.refresh();

  }

  DateTime mergeDateTimeWithTimeOfDay(DateTime date, TimeOfDay time){
    return DateTime.utc(date.year,date.month,date.day,time.hour,time.minute);
  }

  displayBookingCreationStatus(){
    if(bookingCreated.value){
      bookingButtonColors.value = ColorsManager.success;
      bookingButtonText.value = "Booking Created!";
      updateUI();
      Future.delayed(const Duration(seconds: 2),(){
        bookingButtonColors.value = ColorsManager.primary;
        bookingButtonText.value = "Create Booking";
        updateUI();
        Navigator.of(Get.overlayContext!).pop();
      });
    }
  }

  setCheckStatus(){
    for(Map<String,dynamic> checkedDates in selectedConferenceDates.value){
      checkedDates['checked'] = true;
      selectedConferenceDates.refresh();
    }
  }

  updateStartEndTimeForCheckedSelectedDates(bool isStartTime){
    setCheckStatus();
    showTimePicker(context: Get.overlayContext!, initialTime: TimeOfDay.now()).then((value) {
      if(value!=null)  {
        for(Map<String,dynamic> checkedDates in checkedConferenceDates.value){
            checkedDates[isStartTime ? 'startTime': 'endTime'] = parseTimeOfDayToString(value);
            selectedConferenceDates.refresh();
        }

      }
    });

  }



  void addSelectedConferenceDates(DateTime selectedDay, focusDay) {
    List<int> indexesToRemove = [];
    int index= 0;
    logger.i({'title': 'Function addSelectedConferenceDates', 'data': selectedDay.toString()});

    /// Check if date is already selected
    if (selectedConferenceDates.value.isNotEmpty) {
      for (Map<String, dynamic> conferenceDate in selectedConferenceDates.value) {
        if (conferenceDate['date'].toString() == selectedDay.toString()) indexesToRemove.add(index);
        index++;
      }

      for(int i in indexesToRemove){
        selectedConferenceDates.value.removeAt(i);
        selectedConferenceDates.refresh();
        selectedDatesCount.value -= 1;
        logger.i({'title': 'dateRemoved', 'data': selectedDay.toString()});
      }
      selectedConferenceDates.value.add({'date': selectedDay, 'startTime': '', 'endTime': '','checked':false});
      selectedConferenceDates.refresh();
      focusDate.value = selectedDay;
      focusDate.refresh();
      selectedDatesCount.value += 1;

    }else{
      selectedConferenceDates.value.add(
          {'date': selectedDay, 'startTime': '', 'endTime': ''});
      selectedConferenceDates.refresh();
      focusDate.value = selectedDay;
      focusDate.refresh();
      selectedDatesCount.value += 1;
      logger.i({'title': 'dateAdded', 'data': selectedDay.toString()});
    }
    updateUI();
  }

  bool dateIsSelected(DateTime date){
    if(selectedConferenceDates.value.isNotEmpty) {
      /// Check if date is already selected
      for (Map<String, dynamic> conferenceDate in selectedConferenceDates.value) {
        if (conferenceDate['date'] == date) return true;
      }
    }

    return  false;
  }

  String parseTimeOfDayToString(TimeOfDay? time){
    return '${time!.hour }:${time.minute}';
  }



  String get expiryDate {
    bookingExpiryDate.value = extractDate(bookingServiceStartDate.value.add(const Duration(days: -1)));
    return bookingExpiryDate.value;
  }

  updateBookingExpiryDate(){
    bookingExpiryDate.value = extractDate(bookingServiceStartDate.value.add(const Duration(days: -1)));
    bookingExpiryDate.refresh();
  }

  calculateServiceCost(int isRoom){
    if(isRoom == 1) {
      int serviceDurationInDays = bookingServiceEndDate.value.difference(bookingServiceStartDate.value).inDays;
      serviceValueController.text = calculateRoomCost(int.parse(roomNumberController.text),serviceDurationInDays+=1).toString();
      bookingServiceStartDate.refresh();
      bookingServiceEndDate.refresh();

    }
  }

  setPayMethod(String method){
    payMethod.value = method;
    payMethod.refresh();
  }

  Future<void> createRoomBooking({int isRoom=0})async{
    int serviceDurationInDays = bookingServiceEndDate.value.difference(bookingServiceStartDate.value).inDays;
    await ServiceBookingRepository().createServiceBooking(ServiceBooking(
          id: bookServiceId.value,employeeId:authController.adminUser.value.appId,
          bookingDatetime:resetTimeInDateTime(DateTime.now()),roomNumber: int.parse(roomNumberController.text),
          bookingExpiryDateTime: resetTimeInDateTime(bookingServiceStartDate.value.add(const Duration(days: -1))),
          serviceStartDate: resetTimeInDateTime(bookingServiceStartDate.value),
          serviceEndEndDate: bookingServiceEndDate.value.toIso8601String(),
          name: nameController.text,phone: phoneController.text,peopleCount: int.parse(peopleCountController.text),
          serviceValue: isRoom==1 ? calculateRoomCost(int.parse(roomNumberController.text),serviceDurationInDays ) : int.parse(serviceValueController.text),
          advancePayment: advancePaymentController.text, invoiceNo: invoiceNumberController.text,
          bookingType: isRoom == 0 ? 'CONFERENCE':'ROOM', bookingStatus: 'ACTIVE', isRoom: isRoom
    ).toJson()).then((value) async{
      await CollectedPaymentsRepository().createCollectedPayment(CollectPayment(
          id: const Uuid().v1(), roomTransactionId: bookServiceId.value,employeeId: authController.adminUser.value.appId,
          employeeName: authController.adminUser.value.fullName,clientName: nameController.text,clientId: '',
          roomNumber: int.parse(roomNumberController.text),amountCollected: int.parse(advancePaymentController.text),
          date: extractDate(DateTime.now()),time: extractTime(DateTime.now()),dateTime: DateTime.now().toIso8601String(),
          service: 'ROOM:ADVANCE',payMethod: payMethod.value,receiptNumber: ''
      ).toJson());
      });
  }

  Future<void> createConferenceBooking({int isRoom=0})async{
    /// CREATE Service Booking
    /// CREATE ConferenceBookingDetails
    /// CREATE COLLECTED PAYMENT
    bookingInitiated.value = true;
    await ServiceBookingRepository().createServiceBooking(ServiceBooking(
            id: bookServiceId.value,employeeId: authController.adminUser.value.appId,
            bookingDatetime: DateTime.now().toIso8601String(),
            bookingExpiryDateTime: getBiggestDate()['startDate']?.add(const Duration(days: -1)).toIso8601String(),
            serviceStartDate: getBiggestDate()['startDate']?.toIso8601String(),
            serviceEndEndDate: getBiggestDate()['endDate']?.toIso8601String(),
            name: nameController.text,phone: phoneController.text,peopleCount: int.parse(peopleCountController.text),
            serviceValue: int.parse(serviceValueController.text),
            advancePayment: advancePaymentController.text, invoiceNo: invoiceNumberController.text,
            bookingType: TransactionTypes.conferenceBooking, bookingStatus: 'ACTIVE', isRoom: isRoom
        ).toJson()).catchError((onError){
          logger.e('UNABLE to create Service booking',onError);
          return -1;
        }).then((value)async {
          for(Map<String,dynamic> element in selectedConferenceDates.value){
            await ConferenceBookingDetailsRepository().createConferenceBookingDetails(ConferenceBookingDetails(
              id: const Uuid().v1(),
              bookingId: bookServiceId.value,date: element['date'].toString(),
              startTime: element['startTime'],endTime: element['endTime'].toString()
            ).toJson()).then((value)async {
              await CollectedPaymentsRepository().createCollectedPayment(CollectPayment(
                    id: const Uuid().v1(), roomTransactionId: bookServiceId.value,employeeId: authController.adminUser.value.appId,
                      employeeName: authController.adminUser.value.fullName,clientName: nameController.text,clientId: '',
                    roomNumber: 0,amountCollected: int.parse(advancePaymentController.text),
                      date: extractDate(DateTime.now()),time: extractTime(DateTime.now()),dateTime: DateTime.now().toIso8601String(),
                      service: TransactionTypes.conferenceBooking,payMethod: payMethod.value,receiptNumber: ''
              ).toJson()).then((value) {

              });
            });
          }
        });
    bookingInitiated.value = false;
  }

  Map<String,DateTime> getBiggestDate(){
    List<DateTime> dates =[];
    DateTime furthestDate = selectedConferenceDates.value[0]['date'];
    DateTime closestDate = selectedConferenceDates.value[0]['date'];

    for(Map<String,dynamic> bookingDetails in selectedConferenceDates.value){
      dates.add(bookingDetails['date']);
    }

    for(int i =0;i<dates.length;i++){
      if(dates[i].isAfter(furthestDate)){
        furthestDate = dates[i];
      }

      if(dates[i].isBefore(closestDate)){
        closestDate = dates[i];
      }
    }
    return {'startDate': closestDate,'endDate':furthestDate};
  }

}
