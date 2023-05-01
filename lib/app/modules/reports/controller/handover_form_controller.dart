import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/other_transactions_repo.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/modules/reports/controller/report_selector_controller.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/laundry_transactions_source.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/petty_cash_source.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/room_service_source.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/services/calulators/summary_calculator.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:hotel_pms/app/data/local_storage/repository/hotel_issues_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/hotel_issues_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import '../../../../core/logs/local_logger.dart';
import '../../../../core/services/table_services.dart';
import '../../../../core/values/localization/local_keys.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../../../data/models_n/internl_transaction_model.dart';
import '../table_sources/conference_usage_source.dart';
import '../table_sources/rooms_used_table_source.dart';
import '../../user_data/controller/user_data_controller.dart';


class ReportGeneratorController extends GetxController {
  ReportGeneratorController();
  LocalLogger Log = LocalLogger.instance;
  Map<String, dynamic>? reportConfigs;

  AuthController authController = Get.find<AuthController>();
  ReportSelectorController reportSelectorController = Get.find<ReportSelectorController>();

  Rx<List<RoomTransaction>> roomsSoldInCurrentSession =
      Rx<List<RoomTransaction>>([]);
  Rx<List<RoomTransaction>> paginatedRoomsSoldInCurrentSession =
      Rx<List<RoomTransaction>>([]);

  Rx<List<ServiceBooking>> conferenceActivityCurrentSession =
      Rx<List<ServiceBooking>>([]);
  Rx<List<ServiceBooking>> paginatedConferenceActivityCurrentSession =
      Rx<List<ServiceBooking>>([]);

  Rx<List<OtherTransactions>> laundryTransactionsInCurrentSession =
      Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> paginatedLaundryTransactionsInCurrentSession =
      Rx<List<OtherTransactions>>([]);

  Rx<List<OtherTransactions>> roomServiceTransactionsInCurrentSession =
      Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> paginatedRoomServiceTransactionsInCurrentSession =
      Rx<List<OtherTransactions>>([]);

  Rx<List<HotelIssues>> hotelIssuesInCurrentSession = Rx<List<HotelIssues>>([]);
  Rx<List<HotelIssues>> paginatedHotelIssuesInCurrentSession =
      Rx<List<HotelIssues>>([]);

  Rx<List<InternalTransaction>> pettyCashTransactions =
      Rx<List<InternalTransaction>>([]);
  Rx<List<InternalTransaction>> paginatedPettyCashTransactions =
      Rx<List<InternalTransaction>>([]);

  Rx<List<Map<String, GlobalKey<SfDataGridState>>>> reportExportInfo =
      Rx<List<Map<String, GlobalKey<SfDataGridState>>>>([]);

  Rx<bool> isHandoverReport = Rx<bool>(true);

  Rx<AdminUser> loggedInUser = Get.find<AuthController>().adminUser;

  Rx<Map<String, dynamic>> inputBuffer = Rx<Map<String, dynamic>>({});
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController conferencePaymentsCtr = TextEditingController();
  TextEditingController conferenceAdvancePaymentsCtr = TextEditingController();
  TextEditingController roomPaymentsCtr = TextEditingController();
  TextEditingController roomDebtPaymentsCtr = TextEditingController();
  TextEditingController laundryPaymentsCtr = TextEditingController();
  TextEditingController roomServicePaymentsCtr = TextEditingController();
  TextEditingController pettyCashOutCtr = TextEditingController();
  TextEditingController totalDailyPaymentsCtr = TextEditingController();

  List<String> reportTypes = ['Daily', 'Weekly', 'Monthly', 'Custom'];
  Rx<String> selectedReportType = Rx<String>('');

  Rx<bool> isExporting = false.obs;
  Rx<bool> searchBySelectedSession = false.obs;
  Rx<bool> searchByDateRange = false.obs;

  Rx<Map<String, dynamic>> summaryData = Rx<Map<String, dynamic>>({});

  Rx<int> reportDayOffset = Rx<int>(-1);

  Rx<DateTime> reportStartDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime> reportEndDate =
      Rx<DateTime>(DateTime.now().add(const Duration(days: -1)));

  Rx<List<SessionTracker>> existingSessions = Rx<List<SessionTracker>>([]);
  Rx<SessionTracker> selectedSession = Rx<SessionTracker>(SessionTracker());
  Rx<List<String>> existingSessionsView = Rx<List<String>>([]);
  Rx<String> selectedSessionView = "".obs;
  Rx<String> selectedSessionUserName = "".obs;
  Rx<String> roomSummaryValue = "".obs;
  Rx<String> roomServiceSummaryValue = "".obs;
  Rx<String> roomServiceCounterSummaryValue = "".obs;



  Rx<String> roomsSoldCountSummaryValue = "".obs;
  Rx<String> roomDebtValue = "".obs;
  Rx<String> conferenceSummaryValue = "".obs;
  Rx<String> conferenceAdvanceSummaryValue = "".obs;
  Rx<String> laundryCounterSummaryValue = ''.obs;
 // Rx<String> laundrySummaryValue = "".obs;
  Rx<String> laundrySummaryValue = "".obs;

  Rx<String> pettyCashSummaryValue = "".obs;
  // Rx<String> roomServiceSummaryValue = "".obs;
  Logger logger = AppLogger.instance.logger;
  UserData userData = Get.find<UserData>();

  @override
  Future<void> onInit() async {
    super.onInit();
    logger.i(userData.userData.value);
    reportConfigs = reportSelectorController.reportConfigs;
    setReportConfigsFromReportSelector();
    await loadExistingSessions();
    initTextEditingControllers();
    logger.i('Session at innit is ${selectedSession.value.id}');
    // await loadReportData();
    updateUI(onInit: true);
  }

  initTextEditingControllers(){
    roomNumberController.text = "0";
    conferencePaymentsCtr.text = "0";
    conferenceAdvancePaymentsCtr.text = "0";
    roomPaymentsCtr.text = "0";
    roomDebtPaymentsCtr.text = "0";
    laundryPaymentsCtr.text = "0";
    roomServicePaymentsCtr.text = "0";
    pettyCashOutCtr.text = "0";
    totalDailyPaymentsCtr.text = "0";
  }

  clearControllers(){
    roomNumberController.clear();
    conferencePaymentsCtr.clear();
    conferenceAdvancePaymentsCtr.clear();
    roomPaymentsCtr.clear();
    roomDebtPaymentsCtr.clear();
    laundryPaymentsCtr.clear();
    roomServicePaymentsCtr.clear();
    pettyCashOutCtr.clear();
    totalDailyPaymentsCtr.clear();
  }

  clearSummaryValues(){
    pettyCashSummaryValue.value = '';
    roomServiceSummaryValue.value = '';
    laundrySummaryValue.value = '';
    conferenceSummaryValue.value='';
    conferenceAdvanceSummaryValue.value='';
    roomDebtValue.value='';
    roomSummaryValue.value='';
    roomsSoldCountSummaryValue.value='';
  }

  clearDataForNextReport(){
    clearControllers();
    clearSummaryValues();
    reportExportInfo.value.clear();
    summaryData.value.clear();
  }

  Future<void> loadReportData() async {
    await getRoomsSoldInCurrentSession();
    await getConferenceActivityInCurrentSession();
    await getLaundryTransactionsCurrentSession();
    await getRoomServiceTransactionsInCurrentSession();
    await getHotelIssuesInCurrentSession();
    await getPettyCashTransactions();
    updateSummaryValues();
  }

  updateSummaryValues(){
    roomPaymentsCtr.text = SummaryCalculator.calculateRoomAmountPaid(roomsSoldInCurrentSession.value).toString();
    conferencePaymentsCtr.text = SummaryCalculator.calculateConferenceCosts(conferenceActivityCurrentSession.value).toString();
    conferenceAdvancePaymentsCtr.text = SummaryCalculator.calculateConferenceAdvancePayments(conferenceActivityCurrentSession.value).toString();
    laundryPaymentsCtr.text = SummaryCalculator.calculateRoomServiceAmountPaid(laundryTransactionsInCurrentSession.value).toString();
    roomServicePaymentsCtr.text = SummaryCalculator.calculateRoomServiceAmountPaid(roomServiceTransactionsInCurrentSession.value).toString();
    roomDebtPaymentsCtr.text = SummaryCalculator.calculateRoomDebts(roomsSoldInCurrentSession.value).toString();
    pettyCashOutCtr.text = SummaryCalculator.calculatePettyCashGiven(pettyCashTransactions.value).toString();
    updateUI();
  }

  updateUI({bool onInit = false}) {
    // roomsSoldInCurrentSession.refresh();
    // roomsSoldInCurrentSession.update((val) {});
    // conferenceActivityCurrentSession.refresh();
    // laundryTransactionsInCurrentSession.refresh();
    // roomServiceTransactionsInCurrentSession.refresh();
    // hotelIssuesInCurrentSession.refresh();
    // pettyCashTransactions.refresh();
    onInit ? null : update();
  }

  setReportConfigsFromReportSelector() {
    bool isOneDayApart = true;
    if (reportConfigs != null &&
        reportConfigs!.keys.contains('endDate') &&
        reportConfigs!.keys.contains('startDate')) {
      isOneDayApart = isDateDifferenceLessOrEqualTo(
          DateTime.parse(
              reportConfigs?['endDate'] ?? DateTime.now().toIso8601String()),
          DateTime.parse(
              reportConfigs?['startDate'] ?? DateTime.now().toIso8601String()),
          // reportConfigs!['endDate'],
          // reportConfigs! ['startDate'],
          1);
    }

    if (reportConfigs != null && isOneDayApart == false) {
      reportStartDate.value = DateTime.parse(reportConfigs!['startDate']);
      reportEndDate.value = DateTime.parse(reportConfigs!['endDate']);
      isHandoverReport.value = false;
    } else if (isOneDayApart) {
      isHandoverReport.value = true;
    }
  }

  Future<void> submitReport(Map<String, GlobalKey<SfDataGridState>> reportData) async {
    queTableKey(reportData[LocalKeys.kRooms], LocalKeys.kRooms);
    queTableKey(reportData[LocalKeys.kConference], LocalKeys.kConference);
    queTableKey(reportData[LocalKeys.kRoomService], LocalKeys.kRoomService);
    queTableKey(reportData[LocalKeys.kLaundry], LocalKeys.kLaundry);
    queTableKey(reportData[LocalKeys.kHotelIssues], LocalKeys.kHotelIssues);
    queTableKey(reportData[LocalKeys.kPettyCash], LocalKeys.kPettyCash);
    updateSummaryValues();
    await processTableExports();
  }

  queTableKey(GlobalKey<SfDataGridState>? key, String sheetName) {
    if(key!=null) {
      reportExportInfo.value.add({sheetName: key});
    }else{
      Log.exportLog(data: {'title': 'key for table $sheetName'}, error: 'KEY IS NULL');
    }
  }

  Future<void> exportTable(GlobalKey<SfDataGridState> tableKey, {bool toExcel = true}) async {
    if (toExcel) {
      await ExportTableData().exportDataGridToExcel(
          key: tableKey,
          filePath: await FileManager().generateFileName(
              userName: loggedInUser.value.fullName ?? 'system',
              category: 'Reports'),
          fileCategory: 'Reports',
          launchFile: false);
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
    setSummaryData();
    isExporting.value = true;
    String filePath = await FileManager().generateFileName(
        userName: loggedInUser.value.fullName ?? 'system', category: 'Reports');

    ExcelWorkBook excelWorkBook = ExcelWorkBook(
        sheetProperties: reportExportInfo.value, excelFileName: filePath);
    Workbook workbook = await excelWorkBook.createReportSummaryTemplate(summaryData.value,await getReportEmployeeDetails());
    await excelWorkBook.createFileWithSheetsFromSfTable(filePath, workbook);

    isExporting.value = false;
    clearDataForNextReport();

  }

  getReportEmployeeDetails()async{
    if(isHandoverReport.value){
      logger.i('dailyReport');
      return {
        'name': loggedInUser.value.fullName,
        'start': authController.sessionController.currentSession.value.dateCreated,
        'end': DateTime.now().toIso8601String(),
        'session': authController.sessionController.currentSession.value.id,
      };
    }else if(searchByDateRange.value){
      logger.i('dateRangeReport');
      return {
        'name': loggedInUser.value.fullName,
        'start': reportStartDate.value.toIso8601String(),
        'end': reportEndDate.value.toIso8601String(),
        'session': '',


      };
    }else if(searchBySelectedSession.value){
      logger.i('sessionReport');


      return {
        'name': selectedSessionUserName.value,
        'start': selectedSession.value.dateCreated,
        'end': selectedSession.value.dateEnded ?? DateTime.now().toIso8601String(),
        'session': authController.sessionController.currentSession.value.id,


      };

    }
    return {
      'name': 'not_given',
      'start': DateTime.now().toIso8601String(),
      'end': DateTime.now().toIso8601String(),
      'session': '',

    };
  }

  handleHandoverConfigCheckboxState(bool? state){
    if(searchByDateRange.value==false && searchBySelectedSession.value==false){
      isHandoverReport.value = state ?? false;
      isHandoverReport.refresh();
      selectedSession.value = authController.sessionController.currentSession.value;
    }
  }

  handleDateRangeConfigCheckboxState(bool? state){
    if(isHandoverReport.value == false && searchBySelectedSession.value==false){
      searchByDateRange.value= state ?? false;
      searchByDateRange.refresh();
    }
  }

  handleSessionConfigCheckboxState(bool? state) {
    if(isHandoverReport.value == false && searchByDateRange.value==false){
      searchBySelectedSession.value = state ?? false;
      searchBySelectedSession.refresh();
    }

  }

  setSummaryData() {
    // updateUI();
    update();
    logger.i('updated controller');

    summaryData.value.clear();

    summaryData.value = {
      LocalKeys.kRooms: strToDouble(roomPaymentsCtr.text+'.0'),
      '${LocalKeys.kRooms} ${LocalKeys.kDebts}':
          strToDouble(roomDebtPaymentsCtr.text+'.0'),
      LocalKeys.kConference: strToDouble(conferencePaymentsCtr.text+'.0'),
      '${LocalKeys.kConference} Advance':
          strToDouble(conferenceAdvancePaymentsCtr.text+'.0'),
      LocalKeys.kRoomService: strToDouble(roomServicePaymentsCtr.text+'.0'),
      LocalKeys.kLaundry: strToDouble(laundryPaymentsCtr.text+'.0'),
      LocalKeys.kPettyCash: strToDouble(pettyCashOutCtr.text+'.0'),
      LocalKeys.kRoomService+"Count" : strToDouble(roomServiceTransactionsInCurrentSession.value.length.toString()),
      LocalKeys.kRooms+'Count': strToDouble(roomsSoldInCurrentSession.value.length.toString()+'.0'),
      LocalKeys.kLaundry+'Count': strToDouble(laundryTransactionsInCurrentSession.value.length.toString()+'.0'),

    };
    summaryData.refresh();
  }

  setSessionById(String id) {
    for (SessionTracker session in existingSessions.value) {
      if (session.id == id) {
        selectedSession.value = session;
      }
    }
    selectedSession.refresh();
  }

  getSummaryData(String tableTitle, String summaryValue) {
    // logger.wtf('GET SUMMARY DATA $tableTitle $summaryValue');
    try{
      switch (tableTitle) {
        case RoomsUsedColumnNames.paid:
          if(roomSummaryValue.value =='') {
            roomSummaryValue.value = summaryValue;
          }
          break;
        case RoomsUsedColumnNames.debt:
          if(roomDebtValue.value=='') {
            roomDebtValue.value = summaryValue;
          }

          break;
        case ConferenceTableColumnNames.advance:
          if(conferenceAdvanceSummaryValue.value == '') {
            conferenceAdvanceSummaryValue.value = summaryValue;
          }
          break;
        case ConferenceTableColumnNames.totalCost:
          if(conferenceSummaryValue.value=='') {
            conferenceAdvanceSummaryValue.value = summaryValue;
          }

          break;
        case LaundryTableColumnNames.amountPaid:
          if(laundrySummaryValue.value=='') {
            laundrySummaryValue.value = summaryValue;
          }
          break;
        case RoomsServiceColumnNames.amountPaid:
          if(roomServiceSummaryValue.value=='') {
            roomServiceSummaryValue.value = summaryValue;
          }
          break;
        case PettyCashTableColumnNames.amountPaid:
          if(pettyCashSummaryValue.value=='') {
            pettyCashSummaryValue.value = summaryValue;
          }
          break;
        default:
          logger.w('Table name $tableTitle does not exist');
      }
    }catch(e){
      logger.w('summary data error ${e.toString()}');
    }

  }

  setReportType(String reportType) {
    selectedReportType.value = reportType;
    selectedReportType.refresh();
  }

  Future<List<String>> getTransactionIdsByTransactionType(String transactionType) async {
    return getSessionActivityIds(await getTransaction(transactionType));
  }

  List<String> getSessionActivityIds(List<SessionActivity> transactions) {
    List<String> transactionsIds = [];
    for (SessionActivity transaction in transactions) {
      if (transaction.transactionId != null) {
        transactionsIds.add(transaction.transactionId ?? '');
      }
    }
    return transactionsIds;
  }

  Future<void> getPettyCashTransactions() async {
    List<String> pettyCashTransactionsIds = getSessionActivityIds(await getTransaction(TransactionTypes.pettyCash));

    pettyCashTransactions.value = await InternalTransactionRepository()
        .getMultipleInternalTransactionByIds(pettyCashTransactionsIds);
  }

  Future<void> getRoomServiceTransactionsInCurrentSession() async {
    List<String> roomServiceTransactionsIds =
        await getTransactionIdsByTransactionType(
            TransactionTypes.roomServiceTransaction);
    roomServiceTransactionsInCurrentSession.value =
    await OtherTransactionsRepository().getMultipleOtherTransaction(roomServiceTransactionsIds);
  }

  Future<void> getHotelIssuesInCurrentSession() async {
    List<String> hotelIssuesSessionIds =
        await getTransactionIdsByTransactionType(TransactionTypes.hotelIssue);
    hotelIssuesInCurrentSession.value = await HotelIssuesRepository()
        .getMultipleHotelIssues(hotelIssuesSessionIds);
  }

  Future<void> getConferenceActivityInCurrentSession() async {
    List<String> conferenceTransactionsIds =
        await getTransactionIdsByTransactionType(
            TransactionTypes.conferenceBooking);
    conferenceActivityCurrentSession.value = await ServiceBookingRepository()
        .getMultipleServiceBookingsById(conferenceTransactionsIds);
  }

  Future<void> getRoomsSoldInCurrentSession() async {
    List<String> roomTransactionsIds = await getTransactionIdsByTransactionType(TransactionTypes.room);
    roomsSoldInCurrentSession.value = await RoomTransactionRepository().getMultipleRoomTransactions(roomTransactionsIds);
  }


  Future<void> getLaundryTransactionsCurrentSession() async {
    List<String> laundryTransactionsIds =
        await getTransactionIdsByTransactionType(
            TransactionTypes.laundryPayment.toUpperCase());
    laundryTransactionsInCurrentSession.value =
    await OtherTransactionsRepository().getMultipleOtherTransaction(laundryTransactionsIds);
  }



  Future<List<SessionActivity>> getTransaction(String transactionType) async {
    List<SessionActivity> activity = [];
    if (isHandoverReport.value || searchBySelectedSession.value) {
      activity = await SessionManagementRepository()
          .getSessionActivityByTransactionTypeAndSessionId(
              transactionType,
              selectedSession.value.id ??
                  authController.sessionTracker.value.id ??
                  '');

      if(activity.toSet().length > 0){
        logger.i('fetched ${activity.toSet().length} of ${transactionType} from session ${selectedSession.value.id ?? 'selected session was null used current session${authController.sessionTracker.value.id ?? 'auth controller empty'}'}');

      }
    } else {
      activity = await SessionManagementRepository()
          .getSessionActivityByTransactionTypeAndDateRange(
              transactionType,
              reportStartDate.value.toIso8601String(),
              reportEndDate.value.toIso8601String());
      if(activity.toSet().length>0){
        logger.i('fetched ${activity.toSet().length} of ${transactionType} from date range ${extractDate(reportStartDate.value)}-${extractDate(reportEndDate.value)}');

      }
    }

    return activity;
  }

  setSessionForReport(String sessionView) async{
    selectedSessionView.value = sessionView;
    String sessionId = selectedSessionView.value.split('\n\n')[1];
    String employeeId = existingSessions.value.firstWhere((element) => element.id == sessionId).employeeId ?? '';
    selectedSessionUserName.value = userData.userData.value[employeeId];
    setSessionById(sessionId);
    searchBySelectedSession.value = true;
  }

  Future<void> loadExistingSessions() async {
    existingSessions.value.clear();
    existingSessionsView.value.clear();
    await SessionManagementRepository().getAllSessionTrackers().then((value) {
      existingSessions.value = value;
      existingSessions.value.sort((a, b) => DateTime.parse(b.dateCreated!)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(a.dateCreated!).millisecondsSinceEpoch));
    });

    for (SessionTracker session in existingSessions.value) {

      String userName = userData.userData.value[session.employeeId!];


      String startDate = DateTime.parse(session.dateCreated!).day.toString();
      String endDate =
          DateTime.parse(session.dateEnded ?? DateTime.now().toIso8601String())
              .day
              .toString();
      String dayRange =
          startDate == endDate ? '$endDate' : '$startDate - $endDate';
      String dates =
          '        ${getMonthName(DateTime.parse(session.dateCreated ?? DateTime.now().toIso8601String()).month)}, $dayRange';
      String time = extractTime(DateTime.parse(
              session.dateCreated ?? DateTime.now().toIso8601String())) +
          ' - ' +
          extractTime(DateTime.parse(
              session.dateEnded ?? DateTime.now().toIso8601String()));
      existingSessionsView.value
          .add('${userName} ${dates}\n$time\n\n${session.id}');
    }
    // existingSessionsView.value.sort();
    existingSessionsView.refresh();
    logger.i('sessions loaded ${existingSessions.value.length}');

    setSessionById(
        authController.sessionController.currentSession.value.id ?? '');
  }
}
