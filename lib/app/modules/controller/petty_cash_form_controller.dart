import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/petty_cash_repo.dart';
import 'package:hotel_pms/app/data/models_n/internl_transaction_model.dart';
import 'package:hotel_pms/app/data/models_n/petty_cash_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/utils/string_handlers.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/core/values/localization/messages.dart';
import 'package:uuid/uuid.dart';

import '../../data/local_storage/repository/session_management_repo.dart';
import '../../data/models_n/session_activity_model.dart';

class PettyCashFormController extends GetxController {
  TextEditingController beneficiaryNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController transactionValueCtrl = TextEditingController();
  TextEditingController transactionDepartmentCtrl = TextEditingController();

  Rx<String> selectedDepartment = Rx<String>('');
  Rx<String> selectedDepartmentStatus = Rx<String>('');

  Rx<bool> creatingTransaction = false.obs;

  List<String> departments = [
    HotelDepartments.restaurant,
    HotelDepartments.hotelStore,
    HotelDepartments.housekeeping,
    HotelDepartments.kitchen,
    HotelDepartments.reception,
    HotelDepartments.technician,
    HotelDepartments.delivery
  ];

  AuthController authController = Get.find<AuthController>();

  @override
  onInit() {
    transactionValueCtrl.text = "0";
    super.onInit();
  }

  bool validateSelectedDepartment(){
    bool result = true;
    creatingTransaction.value = true;

    if(creatingTransaction.value && selectedDepartment.value.isEmpty){
      selectedDepartmentStatus.value = 'Department ${AppMessages.isNotEmpty.tr}';
      creatingTransaction.value = false;
      return false;
    }

    return result;
  }
  setDepartment(String department) {
    selectedDepartment.value = department;
  }

  Future<void> createPettyCashForm() async {
    creatingTransaction.value = true;
    final String pettyCashId = const Uuid().v1();
    await InternalTransactionRepository()
        .createInternalTransaction(InternalTransaction(
                id: pettyCashId,
                employeeId: authController.adminUser.value.appId,
                beneficiaryName: beneficiaryNameCtrl.text,
                description: descriptionCtrl.text,
                transactionType: LocalKeys.kPettyCash,
                transactionValue: stringToInt(transactionValueCtrl.text),
                department: selectedDepartment.value,
                dateTime: DateTime.now().toIso8601String(),
                beneficiaryId: const Uuid().v1())
            .toJson())
        .then((value) async {
      await PettyCashRepository().createPettyCashTransaction(PettyCashStatus(
        id: const Uuid().v1(),
        employeeId: authController.adminUser.value.appId,
        dateTime: DateTime.now().toIso8601String(),
        availableCash: "0",
        usedCash: "0",
      ).toJson());
    }).then((value) async {
      await SessionManagementRepository().createNewSessionActivity(
          SessionActivity(
            id: const Uuid().v1(),
            sessionId: authController.sessionController.currentSession.value.id,
            transactionType: LocalKeys.kPettyCash,
            transactionId: pettyCashId,
            dateTime: DateTime.now().toIso8601String()
      ).toJson());
    });
    creatingTransaction.value = false;
  }
}
