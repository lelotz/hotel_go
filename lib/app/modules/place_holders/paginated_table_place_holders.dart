
import 'package:flutter/material.dart';

import '../../../widgets/tables/padded_data_table_row.dart';
import '../../../widgets/tables/paged_data_table_source.dart';
import '../../../widgets/text/small_text.dart';

class TablePlaceHolders{
  TablePlaceHolders._();
  static DataTableSource initSource = PagedDataTableSource(
      rows: [],
      cells: (int index) { return [paddedDataCell(text: const SmallText(text: 'Empty'))]; },
      isEmpty: true);
  static List<DataColumn> initColumn = [ const DataColumn(label: SmallText(text:'NO DATA'))];
}