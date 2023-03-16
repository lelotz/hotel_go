import 'package:flutter/material.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';

class PagedTable extends StatelessWidget {
  String pageTitle;
  String headerText;
  List<Widget> columns;
  List<Widget> rows;
  DataTableSource source;
  int rowsPerPage;

  PagedTable({Key? key,required this.headerText,this.rowsPerPage = 8,required this.pageTitle,required this.columns,required this.rows,required this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: BigText(text: headerText,),
        columns: List<DataColumn>.generate(columns.length, (index) {
          return DataColumn(label: columns[index]);
        }),
        source: source,
        rowsPerPage: rowsPerPage,
        showCheckboxColumn: true,

      );
  }
}
