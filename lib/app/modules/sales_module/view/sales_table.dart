import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_table_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/loading_animation/loading_animation.dart';
import '../../../../widgets/text/small_text.dart';

class SalesTable extends GetView<SalesController> {
  SalesTable({Key? key}) : super(key: key);
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final SalesTableSource salesTableSource = SalesTableSource();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(builder: (controller)=>SizedBox(
      height: const Size.fromHeight(815).height,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: controller.isExporting.value ? loadingAnimation(size: 25) :
            IconButton(
                splashRadius: 50,
                onPressed: ()async{controller.exportSalesTable(_key);},
                icon: const Icon(Icons.save)),
          ),
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
                      showSummaryInRow: false,
                      title: 'Amount collected for ${controller.filteredResultsCount.value} : {Sum collected}',
                      columns: [
                        const GridSummaryColumn(
                            name: 'Sum collected',
                            columnName: 'COLLECTED',
                            summaryType: GridSummaryType.sum
                        )
                      ], position: GridTableSummaryRowPosition.top
                  )
                ],
                columns: <GridColumn>[
                  GridColumn(
                      columnName: '#',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
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
                      columnName: 'PAY METHOD',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child:  SmallText(text:LocalKeys.kPayMethod.tr.toUpperCase()))),
                  GridColumn(
                      columnName: 'COLLECTED',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: SmallText(text:LocalKeys.kCollected.tr.toUpperCase()))),
                ],
              ),
            ),
          ) : loadingAnimation(actionStatement: 'Loading Sales : ${controller.tableInitialized.value}')
          ),
          SfDataPager(
            pageCount: controller.collectedPayments.value.length/8,
            controller: controller.pagerController,
            delegate: salesTableSource,
            visibleItemsCount: salesTableSource.rowsPerPage,
          ),
        ],
      ),
    ));
  }
}
