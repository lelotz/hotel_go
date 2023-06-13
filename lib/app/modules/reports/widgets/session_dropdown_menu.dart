import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/modules/reports/controller/handover_form_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../widgets/text/big_text.dart';

class SessionsDropdown extends GetView<ReportGeneratorController> {
  SessionsDropdown({Key? key,required this.selectedSession}) : super(key: key);

  final Rx<SessionTracker> selectedSession;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportGeneratorController>(
      init: ReportGeneratorController(),
        builder: (controller)=> Obx(() => controller.existingSessions.value.isEmpty  ? loadingAnimation(size: 30,actionStatement: 'Loading') :
          Padding(
            padding: EdgeInsets.only(left: const Size.fromWidth(70).width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Shift Collector
                Obx(() => Container(
                  decoration:  BoxDecoration(

                      border: Border.all(color:ColorsManager.darkGrey,width: AppSize.size4/2),
                      borderRadius: BorderRadius.circular(AppSize.size4)
                  ),
                  height: Size.fromHeight(60).height,
                  width: Size.fromWidth(270).width,
                  child: DropdownButton(
                    value: selectedSession.value,
                    isDense: true,
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SmallText(text: 'Chagua shift',),
                    ),
                    underline: SmallText(text: '',),
                    items: controller.existingSessions.value.map((SessionTracker? session) {
                      return DropdownMenuItem(
                        child: SizedBox(
                          width: Size.fromWidth(240).width,
                          child: ListTile(
                            //minVerticalPadding: 8,
                            isThreeLine: true,
                            dense: true,
                            contentPadding: EdgeInsets.only(bottom: 8,left: 5),

                            title: BigText(text:session == null ? 'Loading': controller.userData.userData.value[session.employeeId]),
                            subtitle: SmallText(text:session == null ? 'Loading':controller.getSessionTimeRange(session)),
                            trailing: SmallText(text:session == null ? 'Loading': controller.getSessionDatesRange(session)),
                          ),
                        ),
                        value: session,
                      );
                    }).toList(),
                    onChanged: (SessionTracker? value) {
                      if(value !=null){
                        selectedSession.value = value;
                        selectedSession.refresh();
                        controller.selectedSession.value = value;
                        controller.selectedSession.refresh();
                      }
                    },
                  ),
                ),),

                /// Selected Shift
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BigText(text: 'Shift'),
                      ),

                      // SmallText(text: controller.selectedSessionView.value),
                      SizedBox(
                        height: Size.fromHeight(100).height,
                        child: Obx(() => SizedBox(
                          height: Size.fromHeight(150).height,
                          width: Size.fromWidth(400).width,
                          child: ListTile(

                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: BigText(text:controller.userData.userData.value[controller.selectedSession.value.employeeId]),
                            ),
                            subtitle: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(text:controller.getSessionTimeRange(controller.selectedSession.value)),
                                Expanded(child: SmallText(text:controller.selectedSession.value.id ?? 'ID NOT FOUND',selectable: true,)),

                              ],
                            ),
                            trailing: SmallText(text:controller.getSessionDatesRange(controller.selectedSession.value)),
                          ),
                        ),),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ))
    );
  }
}
