import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../core/services/table_services.dart';
import '../../../../widgets/app_bars/global_app_bar.dart';
import '../../../../widgets/text/small_text.dart';
import '../widgets/filterbox_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesView extends GetView<SalesController> {
  SalesView({Key? key}) : super(key: key);
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      init: SalesController(),
        builder: (controller)=>Scaffold(
          appBar: buildGlobalAppBar(context,appBarTitle: 'Sales',onTitleTap: controller.onReady),
          body: Obx(() => controller.isLoadingData.value ? loadingAnimation() : Padding(
            padding:  const EdgeInsets.all(AppPadding.padding40),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// Table sorting box
                  Center(child: FiltersBox()),

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
                  Obx(() =>  controller.tableInitialized.value ?
                    Card(
                    child: SfDataGrid(
                      rowsPerPage: getMaxTableRows(controller.collectedPayments.value.length),
                      rowsCacheExtent: getMaxTableRows(controller.collectedPayments.value.length),
                      navigationMode: GridNavigationMode.row,
                      //rowsPerPage: 8,

                      columnWidthMode: ColumnWidthMode.auto,
                      checkboxShape: Checkbox(value: true, onChanged: (bool? value) {  },).shape,
                      key: _key,
                      source: controller.saleTableSource!,
                      tableSummaryRows: [
                        GridTableSummaryRow(
                            columns: [
                          const GridSummaryColumn(name: '', columnName: 'COLLECTED', summaryType: GridSummaryType.sum)
                        ], position: GridTableSummaryRowPosition.top)
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
                                child: const SmallText(text:'ROOM NUMBER'))),
                        GridColumn(
                            columnName: 'DATE',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text: 'DATE'))),
                        GridColumn(
                            columnName: 'TIME',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'TIME'))),
                        GridColumn(
                            columnName: 'EMPLOYEE',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'EMPLOYEE'))),
                        GridColumn(
                            columnName: 'CLIENT',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'CLIENT'))),
                        GridColumn(
                            columnName: 'SERVICE',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'SERVICE'))),
                        GridColumn(
                            columnName: 'COLLECTED',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'COLLECTED'))),
                        GridColumn(
                            columnName: 'PAY METHOD',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const SmallText(text:'PAY METHOD'))),
                      ],
                    ),
                  ) : loadingAnimation()
                  )
                ],
              ),
            ),
          )),
    ));
  }
}

