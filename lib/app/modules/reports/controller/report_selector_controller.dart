import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/reports/view/hand_over_form_view.dart';

class ReportSelectorController extends GetxController{
  Map<String,String> reportConfigs = {};
  List<String> reportTypes = ['Daily','Weekly','Monthly','Custom'];
  Rx<String> selectedReportType = Rx<String>('');

  // @override
  // void onInit(){
  //   super.onInit();
  // }

  setReportType(String reportType){
    selectedReportType.value = reportType;
    selectedReportType.refresh();
    setReportConfigs();
    Get.to(()=>HandoverReport(reportConfigs: reportConfigs));
  }
  setReportConfigs(){
    switch (selectedReportType.value){
      case 'Daily': {
        reportConfigs = {
          'startDate': DateTime.now().add(const Duration(days: -1)).toIso8601String(),
          'endDate':DateTime.now().toIso8601String(),
        };
      }
      break;
      case 'Weekly': {
        reportConfigs = {
          'startDate': DateTime.now().add(const Duration(days: -7)).toIso8601String(),
          'endDate':DateTime.now().toIso8601String()
        };
      }
      break;
      case 'Monthly': {
        DateTime now = DateTime.now();
        int lastDayOfMonth = DateTime(now.year,now.month+1,0).day;
        reportConfigs = {
          'startDate': DateTime(now.year,now.month,1).toIso8601String(),
          'endDate': DateTime(now.year,now.month,lastDayOfMonth).toIso8601String()
        };
      }
      break;
      case 'Custom': {
        DateTime now = DateTime.now();
        int lastDayOfMonth = DateTime(now.year,now.month+1,0).day;
        reportConfigs = {
          'startDate': DateTime(now.year,now.month,1).toIso8601String(),
          'endDate':DateTime(now.year,now.month,lastDayOfMonth).toIso8601String()
        };
      }
      break;
    }
  }
}
