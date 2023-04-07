import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';




class SyncFusionDataSource extends DataGridSource {
  SyncFusionDataSource({required List<DataGridRow> sourceData,required this.buildRows}) {
    _sourceData = sourceData;
  }
  DataPagerController pagerController = DataPagerController();
  int startRowIndex= 0, endRowIndex = 0, rowsPerPage = 8;
  Function buildRows;

  // DataPagerDelegate get pagerDelegate => DataPagerDelegateSource(rows: rows, sourceData: _sourceData, startRowIndex: startRowIndex, endRowIndex: endRowIndex, rowsPerPage: rowsPerPage);


  List<DataGridRow> _sourceData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _sourceData;


  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {

    startRowIndex = newPageIndex * rowsPerPage;
    endRowIndex = startRowIndex + rowsPerPage;
    if (startRowIndex < _sourceData.length && endRowIndex <= _sourceData.length) {
      _sourceData =_sourceData
          .getRange(startRowIndex, endRowIndex)
          .toList(growable: false);
      // buildPaginatedDataGridRows();
      notifyDataSourceListeners();
      /// notifyListeners();
    }else{
      _sourceData = [];
    }

    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            child: Text(cell.value.toString()),
          );
        }).toList());
  }

  void buildPaginatedDataGridRows() {
    _sourceData = buildRows();
  }

}
class DataPagerDelegateSource extends DataPagerDelegate{
  int startRowIndex= 0, endRowIndex = 0, rowsPerPage = 8;
  late List<Object> rows;
  late List<DataGridRow> sourceData;
  DataPagerDelegateSource({required this.rows,required this.sourceData,required this.startRowIndex,required this.endRowIndex,required this.rowsPerPage});

  @override
 Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    startRowIndex = newPageIndex * rowsPerPage;
    endRowIndex = startRowIndex + rowsPerPage;
    sourceData
    .getRange(startRowIndex, endRowIndex )
    .toList(growable: false);

   // notifyListeners();
  return true;
 }
}







