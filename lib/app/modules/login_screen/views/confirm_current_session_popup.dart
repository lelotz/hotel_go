import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:hotel_pms/core/values/localization/messages.dart';
import 'package:hotel_pms/widgets/buttons/card_button.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../core/utils/date_formatter.dart';


class ConfirmCurrentSession extends GetView<SessionManager> {
  const ConfirmCurrentSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionManager>(builder: (controller)=>Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.warning_amber),
              SmallText(text: AppMessages.confirmSession.tr),
              CardButton(onPressed: ()async{
                await controller.setCurrentSession(userId: controller.currentUserId.value);
              }, text: LocalKeys.kNewShift.tr),

              Obx(()=>ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.rogueSessions.value.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: SmallText(text: LocalKeys.kFullName.tr + ': ' + controller.rogueSessions.value[index].employeeId.toString(),),
                      subtitle: SmallText(text: extractDate(null,dateFromString:controller.rogueSessions.value[index].dateCreated)),
                      trailing: SmallText(text: extractTime(DateTime.parse(controller.rogueSessions.value[index].dateCreated!)),),
                      onTap: ()async{
                        await controller.setCurrentSession(fromExistingSession: controller.rogueSessions.value[index]);
                      },
                    );
                  })),
            ],
          ),
        ),
      ),
    ));
  }
}

