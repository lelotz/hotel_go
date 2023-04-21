import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/modules/reports/controller/report_selector_controller.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/laundry_transactions_source.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/petty_cash_source.dart';
import 'package:hotel_pms/app/modules/reports/table_sources/room_service_source.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:logger/logger.dart';
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
import '../../../../core/services/table_services.dart';
import '../../../../core/values/localization/local_keys.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import '../../../data/models_n/internl_transaction_model.dart';
import '../table_sources/conference_usage_source.dart';
import '../table_sources/rooms_used_table_source.dart';

class ReportGeneratorController extends GetxController {
  ReportGeneratorController();

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

  Rx<List<CollectPayment>> laundryTransactionsInCurrentSession =
      Rx<List<CollectPayment>>([]);
  Rx<List<CollectPayment>> paginatedLaundryTransactionsInCurrentSession =
      Rx<List<CollectPayment>>([]);

  Rx<List<CollectPayment>> roomServiceTransactionsInCurrentSession =
      Rx<List<CollectPayment>>([]);
  Rx<List<CollectPayment>> paginatedRoomServiceTransactionsInCurrentSession =
      Rx<List<CollectPayment>>([]);

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

  Rx<Map<String, dynamic>> summaryData = Rx<Map<String, dynamic>>({});

  Rx<int> reportDayOffset = Rx<int>(-1);

  Rx<DateTime> reportStartDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime> reportEndDate =
      Rx<DateTime>(DateTime.now().add(const Duration(days: -1)));

  Rx<List<SessionTracker>> existingSessions = Rx<List<SessionTracker>>([]);
  Rx<SessionTracker> selectedSession = Rx<SessionTracker>(SessionTracker());
  Rx<List<String>> existingSessionsView = Rx<List<String>>([]);
  Rx<String> selectedSessionView = "".obs;
  Rx<String> roomSummaryValue = "".obs;
  Logger logger = AppLogger.instance.logger;

  @override
  Future<void> onInit() async {
    super.onInit();
    reportConfigs = reportSelectorController.reportConfigs;
    setReportConfigsFromReportSelector();
    await loadExistingSessions();
    initTextEditingControllers();
    logger.i('Session at innit is ${selectedSession.value.id}');
    // await loadReportData();
    updateUI(onInit: true);
  }

  initTextEditingControllers(){
    // roomNumberController.text = "0";
    // conferencePaymentsCtr.text = "0";
    // conferenceAdvancePaymentsCtr.text = "0";
    // roomPaymentsCtr.text = "0";
    // roomDebtPaymentsCtr.text = "0";
    // laundryPaymentsCtr.text = "0";
    // roomServicePaymentsCtr.text = "0";
    // pettyCashOutCtr.text = "0";
    // totalDailyPaymentsCtr.text = "0";
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
    roomPaymentsCtr.text = roomSummaryValue.value;
    logger.i('roomSummaryValue ${roomSummaryValue.value}');

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

  Future<void> submitReport(
      Map<String, GlobalKey<SfDataGridState>> reportData) async {
    queTableKey(reportData['Rooms']!, "Rooms");
    queTableKey(reportData['Conference']!, "Conference");
    queTableKey(reportData['Room Service']!, "Room Service");
    queTableKey(reportData['Laundry']!, "Laundry");
    queTableKey(reportData['Hotel Issues']!, "Hotel Issues");
    queTableKey(reportData['Petty Cash']!, "Petty Cash");

    await processTableExports();
  }

  queTableKey(GlobalKey<SfDataGridState> key, String sheetName) {
    reportExportInfo.value.add({sheetName: key});
  }

  Future<void> exportTable(GlobalKey<SfDataGridState> tableKey,
      {bool toExcel = true}) async {
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
    isExporting.value = true;
    String filePath = await FileManager().generateFileName(
        userName: loggedInUser.value.fullName ?? 'system', category: 'Reports');

    ExcelWorkBook excelWorkBook = ExcelWorkBook(
        sheetProperties: reportExportInfo.value, excelFileName: filePath);
    setSummaryData();
    Workbook workbook =
        excelWorkBook.createDailyReportSummary(summaryData.value);
    await excelWorkBook.createFileWithSheetsFromSfTable(filePath, workbook);

    isExporting.value = false;
    reportExportInfo.value.clear();
    summaryData.value.clear();
  }

  handleReportConfigurationOptions(bool? isDailyReport) {
    if (isDailyReport != null && isDailyReport) {
      isHandoverReport.value = true;
      isDailyReport = true;
    } else if (isDailyReport != null && isDailyReport == false) {
      isHandoverReport.value = false;
      isDailyReport = false;
    } else {
      isHandoverReport.value = false;
      isDailyReport = false;
    }
  }

  setSummaryData() {
    logger.w('setting summary data');

    summaryData.value = {
      LocalKeys.kRooms: strToDouble(roomPaymentsCtr.text),
      '${LocalKeys.kRooms} ${LocalKeys.kDebts}':
          strToDouble(roomDebtPaymentsCtr.text),
      LocalKeys.kConference: strToDouble(conferencePaymentsCtr.text),
      '${LocalKeys.kConference} Advance':
          strToDouble(conferenceAdvancePaymentsCtr.text),
      LocalKeys.kRoomService: strToDouble(roomServicePaymentsCtr.text),
      LocalKeys.kLaundry: strToDouble(laundryPaymentsCtr.text),
      LocalKeys.kPettyCash: strToDouble(pettyCashOutCtr.text)
    };
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
    try{
      switch (tableTitle) {
        case RoomsUsedColumnNames.paid:
          if(roomSummaryValue.value ==''){
            roomSummaryValue.value = summaryValue;
          }



          break;
        // case RoomsUsedColumnNames.debt:
        //   roomDebtPaymentsCtr.text = summaryValue;
        //   break;
        // case ConferenceTableColumnNames.advance:
        //   conferenceAdvancePaymentsCtr.text = summaryValue;
        //   break;
        // case ConferenceTableColumnNames.totalCost:
        //   conferencePaymentsCtr.text = summaryValue;
        //   break;
        // case LaundryTableColumnNames.amountPaid:
        //   laundryPaymentsCtr.text = summaryValue;
        //   break;
        // case RoomsServiceColumnNames.amountPaid:
        //   roomServicePaymentsCtr.text = summaryValue;
        //   break;
        // case PettyCashTableColumnNames.amountPaid:
        //   pettyCashOutCtr.text = summaryValue;
        //   break;
        default:
        //logger.w('Table name $tableTitle does not exist');
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
        await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(
            roomServiceTransactionsIds,
            TransactionTypes.roomServiceTransaction);
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
    List<String> roomTransactionsIds =
        await getTransactionIdsByTransactionType(TransactionTypes.room);
    roomsSoldInCurrentSession.value = await RoomTransactionRepository()
        .getMultipleRoomTransactions(roomTransactionsIds);
  }

  Future<void> getLaundryTransactionsCurrentSession() async {
    List<String> laundryTransactionsIds =
        await getTransactionIdsByTransactionType(
            TransactionTypes.laundryPayment);
    laundryTransactionsInCurrentSession.value =
        await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(
            laundryTransactionsIds, TransactionTypes.laundryPayment);
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
      if(activity.length > 0){
        logger.i('fetched ${activity.length} of ${transactionType} from session ${selectedSession.value.id ?? 'selected session was null used current session${authController.sessionTracker.value.id ?? 'auth controller empty'}'}');

      }
    } else {
      activity = await SessionManagementRepository()
          .getSessionActivityByTransactionTypeAndDateRange(
              transactionType,
              reportStartDate.value.toIso8601String(),
              reportEndDate.value.toIso8601String());
      if(activity.length>0){
        logger.i('fetched ${activity.length} of ${transactionType} from date range ${extractDate(reportStartDate.value)}-${extractDate(reportEndDate.value)}');

      }
    }

    return activity;
  }

  setSessionForReport(String sessionView) {
    selectedSessionView.value = sessionView;
    String sessionId = selectedSessionView.value.split('\n\n')[1];
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
      String userName = await AdminUserRepository()
          .getAdminUserNameByAppId(session.employeeId!)
          .then((value) => value);

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
