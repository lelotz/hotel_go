import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/buttons/my_outlined_button.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:get/get.dart';
import '../../../../widgets/forms/form_header.dart';
import '../../controller/petty_cash_form_controller.dart';
class PettyCashForm extends GetView<PettyCashFormController> {
  const PettyCashForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PettyCashFormController>(
      init: PettyCashFormController(),
        builder: (controller)=>Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                  children: [
                  Row(
                    children: [
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFieldInput(textEditingController: controller.beneficiaryNameCtrl, hintText: "Name",useBorder: true,),
                      )),
                    ],
                  ),
                  Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldInput(textEditingController: controller.transactionTypeCtrl, hintText: "DPT",useBorder: true,),
                        )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldInput(textEditingController: controller.transactionValueCtrl, hintText: "Value",useBorder: true,),
                        )),
                      ],
                    ),
                  Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldInput(textEditingController: controller.descriptionCtrl, hintText: "Description".toUpperCase(),useBorder: true,maxLines: 10,),
                        )),
                      ],
                    ),
                  ]
                  ),
                  MyOutlinedButton(text: "Submit", onClick: (){
                    controller.createPettyCashForm();
                  })
                ],
              ),
            )




        )
    );
  }
}
