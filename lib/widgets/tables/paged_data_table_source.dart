
import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/tables/padded_data_table_row.dart';



import '../../app/modules/place_holders/paginated_table_place_holders.dart';
import '../text/big_text.dart';

class PagedDataTableSource extends DataTableSource{
  List<Object> rows;
  List<DataCell> Function(int index) cells;
  bool isEmpty;

  PagedDataTableSource({required this.rows,required this.cells,required this.isEmpty});

  @override
  DataRow? getRow(int index) {
    if(rows.isEmpty) rows.add(TablePlaceHolders.onEmptyCells);

    // TODO: implement getRow
    return  DataRow(
        cells: isEmpty ?  TablePlaceHolders.onEmptyCells : cells(index)
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => rows.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}