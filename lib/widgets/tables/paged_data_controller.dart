
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/tables/padded_data_table_row.dart';

import '../../app/data/models_n/internl_transaction_model.dart';


import '../text/big_text.dart';
import '../text/small_text.dart';

class PettyCashTableSource extends DataTableSource{
  List<InternalTransaction> pettyCashTransactions;
  List<String> onEmptySource = ['No Data to display'];
  bool isEmpty = false;

  PettyCashTableSource({required this.pettyCashTransactions,required this.isEmpty});

  @override
  DataRow? getRow(int index) {

    
    return  DataRow(
        cells: pettyCashTransactions.isEmpty || isEmpty ?  [paddedDataCell(text: BigText(text: onEmptySource[index],size: 16,)),] :
        [
          paddedDataCell(text: BigText(text: extractDate(DateTime.parse(pettyCashTransactions[index].dateTime!)),size: 16,)),
          paddedDataCell(text: BigText(text: pettyCashTransactions[index].beneficiaryName!,size: 16)),
          paddedDataCell(text: BigText(text: pettyCashTransactions[index].transactionType!,size: 16)),
          paddedDataCell(text: BigText(text: pettyCashTransactions[index].transactionValue.toString(),size: 16)),
          paddedDataCell(text: SmallText(text: pettyCashTransactions[index].description!,fontWeight: FontWeight.w600,)),
          paddedDataCell(text: BigText(text: pettyCashTransactions[index].employeeId!,size: 16)),
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
 
  int get rowCount => pettyCashTransactions.isEmpty || isEmpty ? onEmptySource.length : pettyCashTransactions.length;

  @override
 
  int get selectedRowCount => 0;
  
}