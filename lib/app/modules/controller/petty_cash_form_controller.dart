import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/petty_cash_repo.dart';
import 'package:hotel_pms/app/data/models_n/internl_transaction_model.dart';
import 'package:hotel_pms/app/data/models_n/petty_cash_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/utils/useful_math.dart';
import 'package:hotel_pms/mock_data/mock_data_api.dart';
import 'package:uuid/uuid.dart';


class PettyCashFormController extends GetxController{
  TextEditingController beneficiaryNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController transactionTypeCtrl = TextEditingController();
  TextEditingController transactionValueCtrl = TextEditingController();

  AuthController authController = Get.find<AuthController>();

  @override
  onInit(){
    beneficiaryNameCtrl.text = mockNames[random(0,mockNames.length)];
    descriptionCtrl.text = "Test testing the test for internal transaction description";
    transactionTypeCtrl.text = "TEST";
    transactionValueCtrl.text = random(10000, 300000).toString();

    super.onInit();
  }

  Future<void> createPettyCashForm()async{
    await InternalTransactionRepository().createInternalTransaction(
        InternalTransaction(
      id: const Uuid().v1(),employeeId: authController.adminUser.value.appId,beneficiaryName: beneficiaryNameCtrl.text,
          description: descriptionCtrl.text,transactionType: transactionTypeCtrl.text,transactionValue: transactionValueCtrl.text,
          dateTime: DateTime.now().toIso8601String(),beneficiaryId: const Uuid().v1()

    ).toJson()).then((value) async{
      await PettyCashRepository().createPettyCashTransaction(
          PettyCashStatus(
        id: const Uuid().v1(),employeeId: authController.adminUser.value.appId,dateTime: DateTime.now().toIso8601String(),
            availableCash: "0",usedCash: "0",
      ).toJson());
    });

  }


}