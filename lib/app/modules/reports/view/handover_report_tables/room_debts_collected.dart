// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import '../../../../../core/values/localization/local_keys.dart';
// import '../../../../../widgets/dialogs/dialod_builder.dart';
// import '../../../../../widgets/loading_animation/loading_animation.dart';
// import '../../../../../widgets/text/big_text.dart';
// import '../../../../../widgets/text/small_text.dart';
// import '../../controller/handover_form_controller.dart';
// import '../../table_sources/room_debts_from_previous_sessions_source.dart';
// import '../../table_sources/rooms_used_table_source.dart';
// import '../hand_over_form_view.dart';
//
// class RoomsDebtsSection extends GetView<ReportGeneratorController> {
//   RoomsDebtsSection({Key? key, required this.roomsDebtTableKey}) : super(key: key);
//
//   final RoomsDebtsSource _roomDebtsSource = RoomsDebtsSource();
//
//   final GlobalKey<SfDataGridState> roomsDebtTableKey;
//   final double minColumnWidth = 150;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ReportGeneratorController>(
//       // init: ReportGeneratorController(),
//         builder: (controller) => Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 /// Table Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const BigText(text: "Malipo ya Vyumba Siku za Nyuma"),
//                     tableHeader(
//                         onRefreshEntries: controller.loadReportData,
//                         title: "Rooms Sold",
//                         onSave: () async {
//                           controller.queTableKey(roomsDebtTableKey, 'Rooms');
//                           await controller.processTableExports();
//                         },
//                         onAddEntry: () {
//                           buildDialog(context, 'Used Rooms Form',
//                               const RoomUsedForm(),
//                               height: 200, width: 350);
//                           // Get.to(()=>CheckInView());
//                         },
//                         onConfirmEntry: () {}),
//                   ],
//                 ),
//                 SfDataGrid(
//                   key: roomsDebtTableKey,
//                   headerGridLinesVisibility: GridLinesVisibility.none,
//                   isScrollbarAlwaysShown: true,
//                   source: _roomDebtsSource,
//                   shrinkWrapRows: true,
//                   verticalScrollPhysics: NeverScrollableScrollPhysics(),
//                   tableSummaryRows: [
//                     GridTableSummaryRow(
//                         title: '{Rooms Sold}',
//                         showSummaryInRow: false,
//                         columns: const [
//                           GridSummaryColumn(
//                               name: "Rooms Sold",
//                               columnName: RoomsDebtsColumnNames.roomNumber,
//                               summaryType: GridSummaryType.count),
//                           GridSummaryColumn(
//                               name: "Value",
//                               columnName: RoomsDebtsColumnNames.value,
//                               summaryType: GridSummaryType.sum),
//                           GridSummaryColumn(
//                               name: "Paid",
//                               columnName: RoomsDebtsColumnNames.paid,
//                               summaryType: GridSummaryType.sum),
//                           GridSummaryColumn(
//                               name: "Debts",
//                               columnName: RoomsDebtsColumnNames.debt,
//                               summaryType: GridSummaryType.sum),
//                         ],
//                         position: GridTableSummaryRowPosition.top)
//                   ],
//                   columns: <GridColumn>[
//                     GridColumn(
//                         columnWidthMode:
//                         ColumnWidthMode.fitByColumnName,
//                         columnName: RoomsDebtsColumnNames.employee,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kEmployee.tr
//                                     .toUpperCase()))),
//                     GridColumn(
//                         columnWidthMode: ColumnWidthMode.fitByColumnName,
//                         columnName: RoomsDebtsColumnNames.roomNumber,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kRoom.tr
//                                     .toUpperCase()))),
//                     GridColumn(
//                         columnWidthMode:
//                         ColumnWidthMode.fitByColumnName,
//                         columnName: RoomsDebtsColumnNames.checkInDate,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kCheckIn.tr
//                                     .toUpperCase()))),
//                     GridColumn(
//                         minimumWidth: minColumnWidth,
//                         columnName: RoomsDebtsColumnNames.value,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kValue.tr
//                                     .toUpperCase()))),
//                     GridColumn(
//                       // columnWidthMode: ColumnWidthMode.fitByCellValue,
//                         minimumWidth: minColumnWidth,
//                         columnName: RoomsDebtsColumnNames.paid,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kPaid.tr
//                                     .toUpperCase()))),
//                     GridColumn(
//                       // columnWidthMode: ColumnWidthMode.fitByCellValue,
//                         minimumWidth: minColumnWidth,
//                         columnName: RoomsDebtsColumnNames.debt,
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: SmallText(
//                                 text: LocalKeys.kDebts.tr
//                                     .toUpperCase()))),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
//
//
// }