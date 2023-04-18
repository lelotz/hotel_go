import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../widgets/text/big_text.dart';

class SessionsDropdown extends GetView<ReportGeneratorController> {
  SessionsDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
      init: ReportGeneratorController(),
        builder: (controller)=> Obx(() => controller.existingSessions.value.length <= 0 ? loadingAnimation(size: 30) :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GeneralDropdownMenu(
                    menuItems: controller.existingSessionsView.value,
                    callback:controller.setSessionForReport,
                    initialItem: "Chagua Shift"),

                Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: 'Shift'),
                      ),

                      SmallText(text: controller.selectedSessionView.value),
                    ],
                  ),
                ))
              ],
            ),
          ))
    );
  }
}
