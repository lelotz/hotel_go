import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:logger/logger.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/services/table_services.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../data/local_storage/repository/admin_user_repo.dart';
import '../../../data/local_storage/repository/collected_payments_repo.dart';
import '../../../data/models_n/admin_user_model.dart';
import '../../login_screen/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

int dayOffset = 0;

class SalesController extends GetxController {
  Logger logger = AppLogger.instance.logger;

  Future<Rx<AdminUser>> get loggedInUser async => Get.find<AuthController>().adminUser;

  TextEditingController searchCtrl = TextEditingController();
  TextEditingController roomNumberCtrl = TextEditingController();
  TextEditingController guestNameCtrl = TextEditingController();
  Rx<DateTime> startDate =
      Rx<DateTime>(DateTime.now().add(const Duration(days: -1)));
  Rx<DateTime> endDate = Rx<DateTime>(DateTime.now());
  Rx<String> selectedServiceFilter = "".obs;
  Rx<String> selectedPayMethodFilter = "".obs;
  Rx<String> selectedEmployeeFilter = "".obs;
  Rx<int> filteredResultsCount = 0.obs;

  Rx<String> filterResultStatus = "".obs;
  Rx<bool> tableInitialized = false.obs;
  Rx<bool> tableDataIsEmpty = true.obs;
  Rx<bool> isExporting = false.obs;

  Rx<List<String>> selectedFilters = Rx<List<String>>([]);
  Rx<int> selectedFiltersCount = 0.obs;
  Rx<List<CollectPayment>> collectedPayments = Rx<List<CollectPayment>>([]);
  Rx<List<CollectPayment>> paginatedCollectedPayments =
      Rx<List<CollectPayment>>([]);

  Rx<int> collectedPaymentsCount = 0.obs;

  Rx<int> amountCollectedToday = 0.obs;

  Rx<String> searchCategory = LocalKeys.kSelectSearchCategory.obs;
  Rx<List<String>> employees = Rx<List<String>>([]);
  Rx<bool> categoryDropdownIsReset = false.obs;
  Rx<bool> isLoadingData = true.obs;

  List<String> searchCategories = [
    CollectedPaymentsTable.employeeName,
    CollectedPaymentsTable.clientName,
    CollectedPaymentsTable.roomTransactionId,
    CollectedPaymentsTable.roomNumber,
  ];

  DataPagerController pagerController = DataPagerController();

  @override
  onInit()async{
    super.onInit();
    tableInitialized.value = false;
    isExporting.value = false;
    await getAllPaymentTransactions();
    await getAmountCollectedToday();
    await getAllEmployees();
    isLoadingData.value = false;
    logger.i({'salesCount': collectedPayments.value.length});
    update();
   // logger.i('initializingSalesController');
  }


  // @override
  // onReady() async {
  //   super.onReady();
  //   tableInitialized.value = false;
  //   isExporting.value = false;
  //   await getAllPaymentTransactions();
  //   await getAmountCollectedToday();
  //   await getAllEmployees();
  //   isLoadingData.value = false;
  //   logger.i({'salesCount': collectedPayments.value.length});
  //
  // }

  updateUI() {
    collectedPaymentsCount.value = collectedPayments.value.length;
    collectedPayments.refresh();
    selectedFilters.refresh();
    selectedFiltersCount.value = selectedFilters.value.length;
    // update();
  }

  void exportSalesTable(GlobalKey<SfDataGridState> salesTableKey,
      {bool toExcel = true}) async {
    if (toExcel) {
      isExporting.value = true;
      await ExportTableData().exportDataGridToExcel(
          key: salesTableKey,
          filePath: await generateSalesFileName(),
          fileCategory: '');
      isExporting.value = false;
    }
  }

  Future<String> generateSalesFileName() async {
    FileManager fileManager = FileManager();
    fileManager.createFolder('Sales');
    String userName = await loggedInUser.then((value) => value.value.fullName!);

    return await fileManager.generateFileName(category: 'Sales',userName: userName);
  }



  clearFilters() async{
    selectedFilters.value.clear();
    startDate.value = DateTime.now();
    endDate.value = startDate.value;
    selectedFilters.value.clear();
    tableInitialized.value = false;
    categoryDropdownIsReset.value = true;
    searchCategory.value = LocalKeys.kSelectSearchCategory;
    await getAllPaymentTransactions();


  }

  validateSearchCategory(String category) {
    if (searchCategory.value == LocalKeys.kSelectSearchCategory) {
      return "Search Category cannot be empty";
    }
    return null;
  }

  setEmployeeFilterValue(String value) {
    selectedEmployeeFilter.value = value;
  }

  setServiceFilterValue(String value) {
    selectedServiceFilter.value = value;
  }

  setPayMethodFilterValue(String value) {
    selectedPayMethodFilter.value = value;
  }

  setSearchCategory(String category) {
    searchCategory.value = category;
  }

  getAllEmployees() async {
    await SqlDatabase.instance
        .read(tableName: AdminUsersTable.tableName, readAll: true)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          employees.value.addIf(
              employees.value.contains(element['fullName']) == false,
              element['fullName']);
        }
      }
      employees.refresh();
    });
  }

  getAllPaymentTransactions() async {
    collectedPayments.value.clear();
    await SqlDatabase.instance
        .read(tableName: CollectedPaymentsTable.tableName, readAll: true)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        for (Map<String, dynamic> element in value) {
          collectedPayments.value.add(CollectPayment.fromJson(element));
        }
        updateUI();

      }
      filteredResultsCount.value = value?.length ?? 0;
      filterResultStatus.value =
          "Matches : ${value!.length} Displaying : ${collectedPayments.value.length}";
    });
    tableInitialized.value = true;
  }

  getTodaysTransactions() async {
    await CollectedPaymentsRepository()
        .getCollectedPaymentsByDate(extractDate(DateTime.now()))
        .then((value) {
      if (value.isNotEmpty) {
        collectedPayments.value.addAll(value);
        selectedFilters.value.add(extractDate(DateTime.now()));
        updateUI();
      }
    });
  }

  getAmountCollectedToday() async {
    for (CollectPayment element in collectedPayments.value) {
      amountCollectedToday.value =
          amountCollectedToday.value + element.amountCollected!;
    }
  }

  filterSelector() async {
    if (searchCategory.value == "") {
      await filterCollectedPaymentsBlindSearch();
    } else {
      await filterCollectedPaymentsByCategory();
    }
    updateUI();
    // setUpTableSource();
  }

  filterCollectedPaymentsByCategory() async {
    tableInitialized.value = false;
    collectedPayments.value.clear();
    String sql =
        " ${searchCategory.value} = ? AND ${CollectedPaymentsTable.dateTime} BETWEEN ? AND ? ";
    List<Object?> whereArgs = [
      searchCtrl.text.length == 3
          ? stringToInt(searchCtrl.text)
          : searchCtrl.text,
      startDate.value.add(const Duration(days: -1)).toIso8601String(),
      endDate.value.toIso8601String()
    ];
    selectedFilters.value.add(searchCategory.value);

    await SqlDatabase.instance
        .read(
            tableName: CollectedPaymentsTable.tableName,
            where: sql,
            whereArgs: whereArgs)
        .then((value) {
      if (value != null && value.isNotEmpty) {

        collectedPayments.value = CollectPayment().fromJsonList(value);
        updateUI();
        logger.v({
          'title': 'SUCCESS Category Filter ',
          'sql': sql,
          'data_length': collectedPayments.value.length,
          'whereArgs': whereArgs
        });

      } else {
        logger.w({
          'title': 'No results from Category Filter query',
          'sql': sql,
          'whereArgs': whereArgs
        });
      }
      tableInitialized.value = true;      filterResultStatus.value =
          "Matches :${value!.length} Displaying : ${collectedPayments.value.length}";
    });
    // setUpTableSource();
  }

  filterCollectedPaymentsBlindSearch() async {
    tableInitialized.value = false;
    collectedPayments.value.clear();
    String sql =
        " ? IN(${CollectedPaymentsTable.clientName},${CollectedPaymentsTable.service},${CollectedPaymentsTable.employeeName},${CollectedPaymentsTable.roomNumber},${CollectedPaymentsTable.roomTransactionId},${CollectedPaymentsTable.payMethod},${CollectedPaymentsTable.amountCollected},${CollectedPaymentsTable.id},${CollectedPaymentsTable.clientId},${CollectedPaymentsTable.employeeId}) AND ${CollectedPaymentsTable.dateTime} BETWEEN ? AND ? ";
    List<Object?> whereArgs = [
      searchCtrl.text.length == 3
          ? stringToInt(searchCtrl.text)
          : searchCtrl.text,
      startDate.value.toIso8601String(),
      endDate.value.toIso8601String()
    ];
    await SqlDatabase.instance
        .read(
            tableName: CollectedPaymentsTable.tableName,
            where: sql,
            whereArgs: whereArgs)
        .then((value) {
      if (value != null && value.isNotEmpty) {

        collectedPayments.value = CollectPayment().fromJsonList(value);
        filteredResultsCount.value = value.length;
        updateUI();
        logger.v({
          'title': 'SUCCESS Blind Filter ',
          'sql': sql,
          'data_length': collectedPayments.value.length,
          'whereArgs': whereArgs
        });

      } else {
        logger.w({
          'title': 'No results from blind query',
          'sql': sql,
          'whereArgs': whereArgs
        });
      }
      tableInitialized.value = true;

      filterResultStatus.value =
          "Matches : ${value!.length} Displaying : ${collectedPaymentsCount.value}";
    });
    // setUpTableSource();
  }

  filterCollectedPayments() async {
    tableInitialized.value = false;
    selectedFilters.value.clear();

    Map<String, dynamic> filters = buildFilterSql([
      {
        'name': CollectedPaymentsTable.employeeName,
        'value': selectedEmployeeFilter.value
      },
      {
        'name': CollectedPaymentsTable.roomNumber,
        'value': stringToInt(roomNumberCtrl.text)
      },
      {
        'name': CollectedPaymentsTable.service,
        'value': selectedServiceFilter.value
      },
      {
        'name': CollectedPaymentsTable.payMethod,
        'value': selectedPayMethodFilter.value
      },
      {'name': CollectedPaymentsTable.clientName, 'value': guestNameCtrl.text}
    ], resetTimeInDateTime(startDate.value),
        resetTimeInDateTime(endDate.value, toEndOfDay: true));

    /// Employee, Client, Date - Range, Room,Service,Pay Method
    await SqlDatabase.instance.read(
      tableName: CollectedPaymentsTable.tableName,
      where: filters['where'],
      whereArgs: filters['whereArgs'],
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        collectedPayments.value.clear();
        collectedPayments.value = CollectPayment().fromJsonList(value);
        updateUI();

      }
      tableInitialized.value = true;
      logger.i({'name': 'matches found ${value!.length}'});
      filterResultStatus.value =
          "Matches : ${value.length} Displaying : ${collectedPaymentsCount.value}";
      filteredResultsCount.value = value.length;
    });
    // setUpTableSource();
  }

  Map<String, dynamic> buildFilterSql(
      List<Map<String, dynamic>> variables, String startDate, String endDate) {
    String join = ' AND ';
    String where = "";
    List<Object?> whereArgs = [];
    List<Map<String, dynamic>> validVariables = [];
    int validVariablesCount = 0;

    for (Map<String, dynamic> element in variables) {
      if (element['value'] != "" && element['value'] != 0)
        validVariables.add(element);
    }
    for (Map<String, dynamic> element in validVariables) {
      where = "$where${element['name']} = ?";
      whereArgs.add(element['value']);
      selectedFilters.value.add(element['name']);
      validVariablesCount += 1;
      if (validVariablesCount != validVariables.length &&
          validVariablesCount != 0) where = where + join;
    }

    where = validVariables.isNotEmpty
        ? "$where$join${CollectedPaymentsTable.dateTime} BETWEEN ? AND ?"
        : "${CollectedPaymentsTable.dateTime} BETWEEN ? AND ?";
    whereArgs.add(startDate);
    whereArgs.add(endDate);
    selectedFilters.value
        .add("startDate ${extractDate(DateTime.parse(startDate))}");
    selectedFilters.value
        .add("startDate ${extractDate(DateTime.parse(endDate))}");
    updateUI();
    logger.i({
      'name': 'filtered sql parameters',
      'where': where,
      'whereArgs': whereArgs
    });

    return {'where': where, 'whereArgs': whereArgs};
  }
}
