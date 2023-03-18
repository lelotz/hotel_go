import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';




class SyncFusionDataSource extends DataGridSource {
  SyncFusionDataSource({required List<DataGridRow> sourceData}) {
    _sourceData = sourceData;
  }

  List<DataGridRow> _sourceData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _sourceData;

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



}