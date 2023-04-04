import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../widgets/text/big_text.dart';
import '../controller/handover_form_controller.dart';

class HotelIssuesSource extends DataGridSource{
  HotelIssuesSource({this.rowsPerPage = 20}) {
    handoverFormController.paginatedHotelIssuesInCurrentSession.value =
        handoverFormController.hotelIssuesInCurrentSession.value;
    buildPaginatedDataGridRows();
  }



  HandoverFormController handoverFormController = Get.find<HandoverFormController>();

  List<DataGridRow> dataGridRows = [];

  int rowsPerPage;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
          return cell.columnName == 'STEPS TAKEN' ? Container(
            height: const Size.fromHeight(300).height,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            child: Text(cell.value.toString()),
          ) : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            child: Text(cell.value.toString()),
          );
        }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    handoverFormController.getSummaryData(summaryColumn?.columnName ?? '',summaryValue);
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: BigText(text: summaryValue),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    num startIndex = newPageIndex * rowsPerPage;
    num endIndex = startIndex + rowsPerPage;
    if (startIndex < handoverFormController.hotelIssuesInCurrentSession.value.length &&
        endIndex <= handoverFormController.hotelIssuesInCurrentSession.value.length) {
      handoverFormController.paginatedHotelIssuesInCurrentSession.value =
          handoverFormController.hotelIssuesInCurrentSession.value
              .getRange(startIndex as int, endIndex as int)
              .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      handoverFormController.paginatedHotelIssuesInCurrentSession.value = [];
    }

    return true;
  }



  buildPaginatedDataGridRows() {
    dataGridRows = handoverFormController
        .paginatedHotelIssuesInCurrentSession.value
        .map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: HotelIssuesTableColumnNames.roomNumber, value: dataGridRow.roomNumber),
        DataGridCell<String>(columnName: HotelIssuesTableColumnNames.issueType, value: dataGridRow.issueType),
        DataGridCell<String>(columnName: HotelIssuesTableColumnNames.status, value: dataGridRow.issueStatus),
        DataGridCell<String>(columnName: HotelIssuesTableColumnNames.description, value: dataGridRow.issueDescription),
        DataGridCell<String>(columnName: HotelIssuesTableColumnNames.stepsTaken, value: dataGridRow.stepsTaken),
      ]);
    }).toList(growable: false);
  }
}

class HotelIssuesTableColumnNames{
  static const String leading = "hotel_issues_";
  static const String issueType = '${leading}issue_type';
  static const String roomNumber = '${leading}room_number';
  static const String status = '${leading}status';
  static const String description = '${leading}description';
  static const String stepsTaken = '${leading}steps_taken';
}