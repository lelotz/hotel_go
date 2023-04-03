import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../core/services/table_services.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../../../../widgets/text/small_text.dart';
import '../controller/sales_table_source.dart';
import '../widgets/filterbox_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesView extends GetView<SalesController> {
  SalesView({Key? key}) : super(key: key);
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  SalesTableSource salesTableSource = SalesTableSource();
  ScrollController scrollController = ScrollController();


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
                    Align(
                      alignment: Alignment.topRight,
                      child: controller.isExporting.value ? loadingAnimation(size: 25) :
                      IconButton(
                          splashRadius: 50,
                          onPressed: ()async{controller.exportSalesTable(_key);},
                          icon: const Icon(Icons.save)),
                    ),
                   controller.initialized ? SizedBox(
                      height: const Size.fromHeight(815).height,
                      child: Column(
                        children: [
                          Obx(() =>  controller.tableInitialized.value ?
                            SizedBox(
                              height: const Size.fromHeight(700).height,
                              child: Card(
                              child: SfDataGrid(
                                columnWidthMode: ColumnWidthMode.auto,
                                checkboxShape: Checkbox(value: true, onChanged: (bool? value) {  },).shape,
                                key: _key,
                                source: salesTableSource,
                                tableSummaryRows: [
                                  GridTableSummaryRow(
                                      columns: [
                                    const GridSummaryColumn(name: '', columnName: 'COLLECTED', summaryType: GridSummaryType.sum)
                                  ], position: GridTableSummaryRowPosition.top
                                  )
                                ],
                                columns: <GridColumn>[
                                  GridColumn(
                                      columnName: '#',
                                      label: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          alignment: Alignment.center,
                                          child: const SmallText(text:'ID',))),
                                  GridColumn(
                                      columnName: 'ROOM NUMBER',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kRoomNumber.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'DATE',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text: LocalKeys.kDate.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'TIME',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kTime.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'EMPLOYEE',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kEmployee.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'CLIENT',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kClient.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'SERVICE',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kService.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'COLLECTED',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: SmallText(text:LocalKeys.kCollected.tr.toUpperCase()))),
                                  GridColumn(
                                      columnName: 'PAY METHOD',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:  SmallText(text:LocalKeys.kPayMethod.tr.toUpperCase()))),
                                ],
                              ),
                          ),
                            ) : loadingAnimation(actionStatement: 'Loading Table Data : ${controller.tableInitialized.value}')
                          ),
                          SfDataPager(
                            pageCount: controller.collectedPayments.value.length/8,
                            controller: controller.pagerController,
                            delegate: salesTableSource,
                            visibleItemsCount: salesTableSource.rowsPerPage,
                          ),
                        ],
                      ),
                    ) : loadingAnimation(actionStatement: 'Initializing')
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}

