
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class InputListExpandablePanelController extends GetxController{
  Rx<ExpandableController> expandableController = Rx<ExpandableController>(ExpandableController());
  Rx<List<Object>> inputValues = Rx<List<Object>>([]);

  @override
  onInit(){
    expandableController.value.toggle();
    super.onInit();

  }

  void expandPanel(){
    if(expandableController.value.expanded == false) expandableController.value.toggle();

    //expandableController.value = true;

    if (kDebugMode) {
      print('toggles ${expandableController.value.expanded}');
    }
    update();
  }

  void addInputValue(List<Object> values){
    if(values.isNotEmpty) expandPanel();
    inputValues.value.addAll(values);
    update();
  }



}