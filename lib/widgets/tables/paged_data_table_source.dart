
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/tables/padded_data_table_row.dart';

import '../../app/data/models_n/internl_transaction_model.dart';


import '../text/big_text.dart';
import '../text/small_text.dart';

class PagedDataTableSource extends DataTableSource{
  List<Object> rows;
  //List<Widget> cells;
  List<String> onEmptySource = ['No Data to display'];
  List<DataCell> Function(int index) cells;
  bool isEmpty = false;

  PagedDataTableSource({required this.rows,required this.cells,required this.isEmpty});

  @override
  DataRow? getRow(int index) {
    if(rows.isEmpty) rows.add('Table is Empty');

    // TODO: implement getRow
    return  DataRow(
        cells: rows.isEmpty || isEmpty ?  [paddedDataCell(text: BigText(text: onEmptySource[index],size: 16,)),] :
        cells(index)
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