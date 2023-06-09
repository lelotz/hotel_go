import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import '../../../core/values/localization/local_keys.dart';
import '../widgtes/forms/complaints_form.dart';
import '../widgtes/forms/hotel_issues_form.dart';
import '../widgtes/forms/petty_cash_form.dart';

class FormSelectorController extends GetxController{
    /// Form Widget, Form Name
  Rx<Map<String,Widget>> formsMap = Rx<Map<String,Widget>>({
    'Complaints': const ComplaintsForm(),LocalKeys.kPettyCash: PettyCashForm(),'Issues': const HotelIssuesForm()
  });
  Rx<List<String>> formNames = Rx<List<String>>([LocalKeys.kPettyCash]);
  Rx<String> selectedForm = Rx<String>("");

  setSelectedForm(String formName){
    selectedForm.value = formName;
  }
  getSelectedForm(BuildContext context,String formName){
    buildDialog(context,formName,formsMap.value[selectedForm.value] ?? const BigText(text: "Error"),width: 400,height: 600);
    update();
  }

  openSelectedForm(String formName){
    selectedForm(formName);
    getSelectedForm(Get.context!, formName);
  }


}