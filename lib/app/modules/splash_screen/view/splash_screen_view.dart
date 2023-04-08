import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/app/modules/splash_screen/controller/splash_screen_controller.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({Key? key}) : super(key: key);

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
                        child: SmallText(text: controller.appDirectory.value),
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
