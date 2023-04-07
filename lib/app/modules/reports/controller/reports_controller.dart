import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/models_n/internl_transaction_model.dart';
import 'package:logger/logger.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../widgets/tables/paged_data_controller.dart';


class ReportsController extends GetxController{
  Logger logger = AppLogger.instance.logger;
  List<String> reportSummaryTitles = ['Rooms Sold','Rooms Occupied','Amount Collected','Laundry','Room Service'];
  Rx<List<InternalTransaction>> pettyCashTransactions = Rx<List<InternalTransaction>>([]);
  Rx<int> growableLength = 0.obs;
  ExpandableController expandableController = ExpandableController();
  Rx<bool> pettyCashTransactionAreEmpty = false.obs;
  InternalTransaction mockData = InternalTransaction(
    id: '1',
    employeeId: '1',
    dateTime: DateTime.now().toIso8601String(),
    description: 'Empty',
    beneficiaryId: '',
    beneficiaryName: 'Empty',
    transactionType: '',
    transactionValue: 0,


  );

  DataTableSource? pettyCashSource;

  @override
  onInit()async{
    super.onInit();
    await getPettyCashTransactions().then((value) {
      pettyCashSource = PettyCashTableSource(pettyCashTransactions: pettyCashTransactions.value,isEmpty: false);
    });
    expandableController.addListener(() async {
      if(expandableController.expanded) await getPettyCashTransactions();
    });

  }



  increment(){
    growableLength.value += 2;
    update();
  }
  decrement(){
    if(growableLength.value >0 ) growableLength.value -= 2;
    update();
  }

  int getReportSummaryMockData(String reportType){
    switch (reportType){
      case 'Rooms Sold': return  random(1,7);
      case 'Rooms Occupied': return  random(1,19);
      case 'Amount Collected': return  random(30000,500000);
      case 'Laundry': return  random(1000,30000);
      case 'Room Service':return  random(10000,100000);
      default : return 0;
    }
  }
  Future<void> getPettyCashTransactions()async{
    pettyCashTransactions.value.clear();
    // await InternalTransactionRepository().getInternalTransactionByDate(DateTime.now().add(Duration(days: -3)).toIso8601String())?.then((value) {
    //   pettyCashTransactions.value.addAll(InternalTransaction().fromJsonList(value ?? []));
    //   logger.i({'getPettyTransactions': value ?? []});
    //   update();
    // });
    await InternalTransactionRepository().getAllInternalTransaction()?.then((value) {
      pettyCashTransactions.value.addAll(InternalTransaction().fromJsonList(value!.isEmpty ? [mockData.toJson()] : value));
      if(value.isEmpty) pettyCashTransactionAreEmpty.value = true;
      logger.i({'getPettyTransactions': pettyCashTransactions.value.toList()});
      update();
    });
  }

}