
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/hotel_issues_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/hotel_issues_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/tables/padded_data_table_row.dart';
import '../../../../widgets/tables/paged_data_table_source.dart';
import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/small_text.dart';
import '../../place_holders/paginated_table_place_holders.dart';
import 'input_list_exapandable_panel_controller.dart';

class HandoverFormController extends GetxController{

  /// Title, description, value
  Rx<List<Map<String,dynamic>>> conferencePayments = Rx<List<Map<String,dynamic>>>([]);
  Rx<List<Map<String,dynamic>>> laundryPayments = Rx<List<Map<String,dynamic>>>([]);
  Rx<List<Map<String,dynamic>>> roomDebtPayments = Rx<List<Map<String,dynamic>>>([]);
  Rx<List<Map<String,dynamic>>> otherPayments = Rx<List<Map<String,dynamic>>>([]);
  Rx<List<RoomTransaction>> roomsSoldInCurrentSession =Rx<List<RoomTransaction>>([]);
  Rx<List<ServiceBooking>> conferenceActivityCurrentSession =Rx<List<ServiceBooking>>([]);
  Rx<List<CollectPayment>> laundryTransactionsInCurrentSession =Rx<List<CollectPayment>>([]);
  Rx<List<CollectPayment>> roomServiceTransactionsInCurrentSession =Rx<List<CollectPayment>>([]);
  Rx<List<HotelIssues>> hotelIssuesInCurrentSession = Rx<List<HotelIssues>>([]);
  Rx<Map<String,dynamic>> inputBuffer = Rx<Map<String,dynamic>>({});
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController conferencePaymentsCtr = TextEditingController();
  TextEditingController roomPaymentsCtr = TextEditingController();
  TextEditingController roomDebtPaymentsCtr = TextEditingController();
  TextEditingController laundryPaymentsCtr = TextEditingController();
  TextEditingController roomServicePaymentsCtr = TextEditingController();
  TextEditingController totalDailyPaymentsCtr = TextEditingController();

  DataTableSource? roomsUsedTableSource;
  DataTableSource? roomServiceUsageTableSource;
  DataTableSource? laundryUsageTableSource;
  DataTableSource? conferenceUsageTableSource;
  DataTableSource? hotelIssuesTableSource;



  @override
  Future<void> onInit()async{
    super.onInit();
    await getRoomsSoldInCurrentSession();
    await getConferenceActivityInCurrentSession();
    await getLaundryTransactionsCurrentSession();
    await getRoomServiceTransactionsInCurrentSession();
    await getHotelIssuesInCurrentSession();
    setupTableSources();

    conferencePaymentsCtr.text = random(0,500000).toString();
    update();
  }



  setupTableSources(){
    roomsUsedTableSource = PagedDataTableSource(
        rows: roomsSoldInCurrentSession.value,
        cells: (int index) {
          return [
            paddedDataCell(text: BigText(text: roomsSoldInCurrentSession.value[index].roomNumber.toString())),
            paddedDataCell(text: BigText(text: roomsSoldInCurrentSession.value[index].roomCost.toString())),
            paddedDataCell(text: BigText(text: roomSoldXTimes(roomsSoldInCurrentSession.value[index].roomNumber!).toString())),
            paddedDataCell(text: BigText(text: roomsSoldInCurrentSession.value[index].employeeId.toString())),
            paddedDataCell(text: BigText(text: roomsSoldInCurrentSession.value[index].clientId.toString())),

          ];
        },
        isEmpty: false
    );
    conferenceUsageTableSource = PagedDataTableSource(
        rows: conferenceActivityCurrentSession.value,
        cells: (index){
          return [
            paddedDataCell(text: BigText(text: conferenceActivityCurrentSession.value[index].name!)),
            paddedDataCell(text: BigText(text: conferenceActivityCurrentSession.value[index].bookingType!)),
            paddedDataCell(text: BigText(text: conferenceActivityCurrentSession.value[index].advancePayment!)),
            paddedDataCell(text: BigText(text: conferenceActivityCurrentSession.value[index].serviceValue.toString())),

          ];
        }, isEmpty: false
    );
    roomServiceUsageTableSource = PagedDataTableSource(
        rows: roomServiceTransactionsInCurrentSession.value,
        cells: (int index){
          return [
            paddedDataCell(text: BigText(text: roomServiceTransactionsInCurrentSession.value[index].roomNumber.toString())),
            paddedDataCell(text: BigText(text: roomServiceTransactionsInCurrentSession.value[index].clientName.toString())),
            paddedDataCell(text: BigText(text: roomServiceTransactionsInCurrentSession.value[index].amountCollected.toString())),
            paddedDataCell(text: BigText(text: roomServiceTransactionsInCurrentSession.value[index].service.toString())),
            paddedDataCell(text: BigText(text: roomServiceTransactionsInCurrentSession.value[index].employeeName.toString())),
          ];
        }, isEmpty: false
    );
    laundryUsageTableSource = PagedDataTableSource(
        rows: laundryTransactionsInCurrentSession.value,
        cells: (int index){
          return [
            paddedDataCell(text: BigText(text: laundryTransactionsInCurrentSession.value[index].roomNumber.toString())),
            paddedDataCell(text: BigText(text: laundryTransactionsInCurrentSession.value[index].clientName.toString())),
            paddedDataCell(text: BigText(text: laundryTransactionsInCurrentSession.value[index].amountCollected.toString())),
            paddedDataCell(text: BigText(text: laundryTransactionsInCurrentSession.value[index].service.toString())),
            paddedDataCell(text: BigText(text: laundryTransactionsInCurrentSession.value[index].employeeName.toString())),

          ];
        }, isEmpty: false);
    hotelIssuesTableSource = PagedDataTableSource(
        rows: hotelIssuesInCurrentSession.value,
        cells: (int index){
          return [
            paddedDataCell(text: BigText(text: hotelIssuesInCurrentSession.value[index].roomNumber.toString())),
            paddedDataCell(text: BigText(text: hotelIssuesInCurrentSession.value[index].issueType.toString())),
            paddedDataCell(text: BigText(text: hotelIssuesInCurrentSession.value[index].issueStatus.toString())),
            paddedDataCell(text: BigText(text: hotelIssuesInCurrentSession.value[index].issueDescription.toString())),
            paddedDataCell(text: BigText(text: hotelIssuesInCurrentSession.value[index].stepsTaken.toString(),)),

          ];
        },
        isEmpty: false
    );
  }

  int roomSoldXTimes(int roomNumber){
    int timesSold = 0;
    for(RoomTransaction roomTransaction in roomsSoldInCurrentSession.value){
      if(roomTransaction.roomNumber == roomNumber) timesSold++;
    }
    return timesSold;
  }

  setConferenceInputBuffer(DateTime selectedDate){
    selectedDate = DateTime.now();
    conferencePaymentsCtr.text = random(0,500000).toString();
    inputBuffer.value.clear();
    inputBuffer.value = {
      'id': const Uuid().v1(),
      LocalKeys.kTitle: 'CONFERENCE PAYMENT',
      LocalKeys.kDescription: extractDate(selectedDate),
      LocalKeys.kValue: conferencePaymentsCtr.text
    };
    //update();
  }

  Future<List<String>> getTransactionIdsByTransactionType(String transactionType)async{
    List<SessionActivity> transactions = await getTransaction(transactionType);
    List<String> transactionsIds  = [];
    for(SessionActivity transaction in transactions){
      if(transaction.transactionId != null ) transactionsIds.add(transaction.transactionId ?? '');
    }
    return transactionsIds;
  }

  Future<void> getRoomServiceTransactionsInCurrentSession()async{
    List<String> roomServiceTransactionsIds  = await getTransactionIdsByTransactionType(TransactionTypes.roomServiceTransaction);
    roomServiceTransactionsInCurrentSession.value = await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(roomServiceTransactionsIds, TransactionTypes.roomServiceTransaction);

  }

  Future<void> getHotelIssuesInCurrentSession()async{
    List<String> hotelIssuesSessionIds = await getTransactionIdsByTransactionType(TransactionTypes.hotelIssue);
    hotelIssuesInCurrentSession.value = await HotelIssuesRepository().getMultipleHotelIssues(hotelIssuesSessionIds);
  }

  Future<void> getConferenceActivityInCurrentSession()async{
    List<String> conferenceTransactionsIds  = await getTransactionIdsByTransactionType(TransactionTypes.conferenceBooking);
    conferenceActivityCurrentSession.value = await ServiceBookingRepository().getMultipleServiceBookingsById(conferenceTransactionsIds);
  }

  Future<void> getRoomsSoldInCurrentSession()async{
    List<String> roomTransactionsIds  = await getTransactionIdsByTransactionType(TransactionTypes.room);
    roomsSoldInCurrentSession.value = await RoomTransactionRepository().getMultipleRoomTransactions(roomTransactionsIds);
  }

  Future<void> getLaundryTransactionsCurrentSession()async{
    List<String> laundryTransactionsIds  = await getTransactionIdsByTransactionType(TransactionTypes.laundryPayment);
    laundryTransactionsInCurrentSession.value = await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(laundryTransactionsIds, TransactionTypes.laundryPayment);
  }

  Future<List<SessionActivity>> getTransaction(String transactionType)async{
    /// TODO: Add sessionId query
    List<SessionActivity> activity = await SessionManagementRepository().getSessionActivityByTransactionType(transactionType);
    logger.i({transactionType:activity.length});
    return activity;
  }

  void submitInput(){
    conferencePayments.value.add(inputBuffer.value);
    update();
  }
  
}