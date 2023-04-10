import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:hotel_pms/app/modules/sales_module/view/sales_table.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../widgets/filterbox_widget.dart';


class SalesView extends GetView<SalesController> {
  SalesView({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SalesController>(
      init: SalesController(),
        builder: (controller)=>Scaffold(
          appBar: buildGlobalAppBar(context,appBarTitle: LocalKeys.kSales.tr,onTitleTap: controller.onReady,onBackButton: (){
            Get.back();
            Get.delete<SalesController>();
          }),
          body: Obx(() => controller.isLoadingData.value ? loadingAnimation(actionStatement: 'Loading Table Data') : Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: Padding(
              padding:  const EdgeInsets.all(AppPadding.padding40),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Table sorting box
                    FiltersBox(),
                    SizedBox(height: const Size.fromHeight(20).height,),
                    /// Room Sales Table
                   controller.initialized ? SalesTable() : loadingAnimation(actionStatement: 'Initializing')
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}

