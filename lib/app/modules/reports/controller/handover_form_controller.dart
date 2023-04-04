import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/laundry_transactions_source.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/room_service_source.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/hotel_issues_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/hotel_issues_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/table_services.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/values/localization/local_keys.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../table_sources/conference_usage_source.dart';
import '../table_sources/rooms_used_table_source.dart';
class HandoverFormController extends GetxController {

  /// Title, description, value
  Rx<List<Map<String, dynamic>>> conferencePayments = Rx<
      List<Map<String, dynamic>>>([]);
  Rx<List<Map<String, dynamic>>> laundryPayments = Rx<
      List<Map<String, dynamic>>>([]);
  Rx<List<Map<String, dynamic>>> roomDebtPayments = Rx<
      List<Map<String, dynamic>>>([]);
  Rx<List<Map<String, dynamic>>> otherPayments = Rx<List<Map<String, dynamic>>>(
      []);

  Rx<List<RoomTransaction>> roomsSoldInCurrentSession = Rx<
      List<RoomTransaction>>([]);
  Rx<List<RoomTransaction>> paginatedRoomsSoldInCurrentSession = Rx<
      List<RoomTransaction>>([]);

  Rx<List<ServiceBooking>> conferenceActivityCurrentSession = Rx<
      List<ServiceBooking>>([]);
  Rx<List<ServiceBooking>> paginatedConferenceActivityCurrentSession = Rx<
      List<ServiceBooking>>([]);


  Rx<List<CollectPayment>> laundryTransactionsInCurrentSession = Rx<
      List<CollectPayment>>([]);
  Rx<List<CollectPayment>> paginatedLaundryTransactionsInCurrentSession = Rx<
      List<CollectPayment>>([]);


  Rx<List<CollectPayment>> roomServiceTransactionsInCurrentSession = Rx<
      List<CollectPayment>>([]);
  Rx<List<
      CollectPayment>> paginatedRoomServiceTransactionsInCurrentSession = Rx<
      List<CollectPayment>>([]);

  Rx<List<HotelIssues>> hotelIssuesInCurrentSession = Rx<List<HotelIssues>>([]);
  Rx<List<HotelIssues>> paginatedHotelIssuesInCurrentSession = Rx<
      List<HotelIssues>>([]);

  List<GlobalKey<SfDataGridState>> tableKeys = [];
  Rx<List<Map<String, GlobalKey<SfDataGridState>>>> reportExportInfo = Rx<List<Map<String, GlobalKey<SfDataGridState>>>>([]);

  Rx<AdminUser> loggedInUser = Get
      .find<AuthController>()
      .adminUser;

  Rx<Map<String, dynamic>> inputBuffer = Rx<Map<String, dynamic>>({});
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController conferencePaymentsCtr = TextEditingController();
  TextEditingController conferenceAdvancePaymentsCtr = TextEditingController();
  TextEditingController roomPaymentsCtr = TextEditingController();
  TextEditingController roomDebtPaymentsCtr = TextEditingController();
  TextEditingController laundryPaymentsCtr = TextEditingController();
  TextEditingController roomServicePaymentsCtr = TextEditingController();
  TextEditingController totalDailyPaymentsCtr = TextEditingController();

  Rx<bool> isExporting = false.obs;

  Rx<Map<String, dynamic>> summaryData = Rx<
      Map<String, dynamic>>({});


  @override
  Future<void> onInit() async {
    super.onInit();
    await getRoomsSoldInCurrentSession();
    await getConferenceActivityInCurrentSession();
    await getLaundryTransactionsCurrentSession();
    await getRoomServiceTransactionsInCurrentSession();
    await getHotelIssuesInCurrentSession();

  }

  // @override
  // onReady(){update();}

  queTableKey(GlobalKey<SfDataGridState> key, String sheetName) {
    reportExportInfo.value.add({sheetName: key});
    tableKeys.add(key);
  }

  Future<void> exportTable(GlobalKey<SfDataGridState> tableKey,
      {bool toExcel = true}) async {
    if (toExcel) {
      await ExportTableData().exportDataGridToExcel(
          key: tableKey,
          filePath: await FileManager().generateFileName(
              userName: loggedInUser.value.fullName ?? 'system',
              category: 'Reports'),
          fileCategory: 'Reports', launchFile: false);
    } else {
      await ExportTableData().exportDataGridToPdf(
          key: tableKey,
          filePath: await FileManager().generateFileName(
              userName: loggedInUser.value.fullName ?? 'system',
              category: 'Reports'),
          fileCategory: 'Reports');
    }
  }

  Future<void> processTableExports() async {
    isExporting.value = true;
    logger.i(reportExportInfo.value);
    String filePath = await FileManager().generateFileName(
        userName: loggedInUser.value.fullName ?? 'system',
        category: 'Reports');
    ExcelWorkBook excelWorkBook = ExcelWorkBook(
        sheetProperties: reportExportInfo.value,
        excelFileName: filePath);
    setSummaryData();
    Workbook workbook = excelWorkBook.createDailyReportSummary(summaryData.value);
    await excelWorkBook.createFileWithSheetsFromSfTable(filePath,workbook);

    isExporting.value = false;
    reportExportInfo.value.clear();
    summaryData.value.clear();
    tableKeys.clear();
  }

  setSummaryData(){
    summaryData.value = {
      LocalKeys.kRooms: strToDouble(roomPaymentsCtr.text),
      '${LocalKeys.kRooms} ${LocalKeys.kDebts}': strToDouble(roomDebtPaymentsCtr.text),
      LocalKeys.kConference: strToDouble(conferencePaymentsCtr.text),
      '${LocalKeys.kConference} Advance' : strToDouble(conferenceAdvancePaymentsCtr.text),
      LocalKeys.kRoomService : strToDouble(roomServicePaymentsCtr.text),
      LocalKeys.kLaundry : strToDouble(laundryPaymentsCtr.text),
    };
  }

  getSummaryData(String tableTitle,String summaryValue){

    switch (tableTitle){
      case RoomsUsedColumnNames.paid : roomPaymentsCtr.text = summaryValue;
      break;
      case RoomsUsedColumnNames.debt : roomDebtPaymentsCtr.text = summaryValue;
      break;
      case ConferenceTableColumnNames.advance : conferenceAdvancePaymentsCtr.text = summaryValue;
      break;
      case ConferenceTableColumnNames.totalCost : conferencePaymentsCtr.text = summaryValue;
      break;
      case LaundryTableColumnNames.amountPaid : laundryPaymentsCtr.text = summaryValue;
      break;
      case RoomsServiceColumnNames.amountPaid : roomServicePaymentsCtr.text = summaryValue;
      break;
      default : logger.w('Table name $tableTitle does not exist');

    }
  }


  int roomSoldXTimes(int roomNumber) {
    int timesSold = 0;
    for (RoomTransaction roomTransaction in roomsSoldInCurrentSession.value) {
      if (roomTransaction.roomNumber == roomNumber) timesSold++;
    }
    return timesSold;
  }

  setConferenceInputBuffer(DateTime selectedDate) {
    selectedDate = DateTime.now();
    conferencePaymentsCtr.text = random(0, 500000).toString();
    inputBuffer.value.clear();
    inputBuffer.value = {
      'id': const Uuid().v1(),
      LocalKeys.kTitle: 'CONFERENCE PAYMENT',
      LocalKeys.kDescription: extractDate(selectedDate),
      LocalKeys.kValue: conferencePaymentsCtr.text
    };
    //update();
  }

  Future<List<String>> getTransactionIdsByTransactionType(
      String transactionType) async {
    List<SessionActivity> transactions = await getTransaction(transactionType);
    List<String> transactionsIds = [];
    for (SessionActivity transaction in transactions) {
      if (transaction.transactionId != null) {
        transactionsIds.add(
          transaction.transactionId ?? '');
      }
    }
    return transactionsIds;
  }

  Future<void> getRoomServiceTransactionsInCurrentSession() async {
    List<String> roomServiceTransactionsIds = await getTransactionIdsByTransactionType(
        TransactionTypes.roomServiceTransaction);
    roomServiceTransactionsInCurrentSession.value =
    await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(
        roomServiceTransactionsIds, TransactionTypes.roomServiceTransaction);
  }

  Future<void> getHotelIssuesInCurrentSession() async {
    List<
        String> hotelIssuesSessionIds = await getTransactionIdsByTransactionType(
        TransactionTypes.hotelIssue);
    hotelIssuesInCurrentSession.value =
    await HotelIssuesRepository().getMultipleHotelIssues(hotelIssuesSessionIds);
  }

  Future<void> getConferenceActivityInCurrentSession() async {
    List<
        String> conferenceTransactionsIds = await getTransactionIdsByTransactionType(
        TransactionTypes.conferenceBooking);
    conferenceActivityCurrentSession.value =
    await ServiceBookingRepository().getMultipleServiceBookingsById(
        conferenceTransactionsIds);
  }

  Future<void> getRoomsSoldInCurrentSession() async {
    List<String> roomTransactionsIds = await getTransactionIdsByTransactionType(
        TransactionTypes.room);
    roomsSoldInCurrentSession.value =
    await RoomTransactionRepository().getMultipleRoomTransactions(
        roomTransactionsIds);
  }

  Future<void> getLaundryTransactionsCurrentSession() async {
    List<
        String> laundryTransactionsIds = await getTransactionIdsByTransactionType(
        TransactionTypes.laundryPayment);
    laundryTransactionsInCurrentSession.value =
    await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(
        laundryTransactionsIds, TransactionTypes.laundryPayment);
  }

  Future<List<SessionActivity>> getTransaction(String transactionType) async {
    /// TODO: Add sessionId query
    List<SessionActivity> activity = await SessionManagementRepository()
        .getSessionActivityByTransactionType(transactionType);
    logger.i({transactionType: activity.length});
    return activity;
  }

  void submitInput() {
    conferencePayments.value.add(inputBuffer.value);
    update();
  }

}