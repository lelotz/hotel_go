
import 'package:flutter/material.dart';

import '../../../widgets/illustrations/empty_illustration.dart';
import '../../../widgets/tables/padded_data_table_row.dart';
import '../../../widgets/tables/paged_data_table_source.dart';
import '../../../widgets/text/small_text.dart';

class TablePlaceHolders{
  TablePlaceHolders._();
  static DataTableSource initSource = PagedDataTableSource(
      rows: [const EmptyIllustration()],
      cells: (int index) { return onEmptyCells; },
      isEmpty: true);
  static List<DataCell> onEmptyCells = [paddedDataCell(text:  const EmptyIllustration())];
  static List<DataColumn> initColumn = [ const DataColumn(label: SmallText(text:'Empty'))];
}