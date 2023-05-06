import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/app/modules/splash_screen/controller/splash_screen_controller.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../core/values/localization/localization_controller.dart';

class SplashScreen extends GetView<SplashScreenController> {
  SplashScreen({Key? key}) : super(key: key);
  final LocalizationController langController = Get.put(LocalizationController(),permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
        init: SplashScreenController(),
        builder: (controller) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Column(
                          children: [
                            SmallText(text: controller.appDirectory.value),
                            SmallText(text: controller.currentStep.value),

                          ],
                        ))
                      ),
                    ),
                    controller.isInitialized.value
                        ? const SizedBox()
                        : loadingAnimation(actionStatement: 'Initializing',size: 30),
                  ],
                ),
              ),
            ));
  }
}
