import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';

import '../controller/report_selector_controller.dart';

class ReportSelector extends GetView<ReportSelectorController> {
  const ReportSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportSelectorController>(
        init: ReportSelectorController(),
        builder: (controller) => GeneralDropdownMenu(
              menuItems: controller.reportTypes,
              callback: controller.setReportType,
              initialItem: 'Reports',
              userBorder: false,
            ));
  }
}
