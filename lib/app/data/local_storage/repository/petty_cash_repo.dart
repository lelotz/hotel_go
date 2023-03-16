

import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class PettyCashRepository extends SqlDatabase{
  PettyCashRepository();

  Future<int?>? createPettyCashTransaction(Map<String,dynamic> row)async{
    return create(PettyCashTable.tableName,row );
  }

  Future<List<Map<String, dynamic>>?> getPettyCashStatusByDateAndEmployee(String employeeId,String date)async{
    return await read(tableName: PettyCashTable.tableName,
    where: '${PettyCashTable.employeeId}=? AND ${PettyCashTable.dateTime} BETWEEN ? AND ?',
    whereArgs: [
      employeeId,
      DateTime.parse(date).add(const Duration(days: -1)),
      DateTime.parse(date).add(const Duration(days: 1)),
    ]
    );
  }


}

class PettyCashTable{
  static const String tableName = "petty_cash";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String dateTime = "dateTime";
  static const String availableCash = "availableCash";
  static const String usedCash = "usedCash";

  String sql =
  '''
        CREATE TABLE IF NOT EXISTS $tableName(
        $availableCash TEXT NOT NULL,
        $usedCash TEXT NULL,
        $dateTime DATETIME NOT NULL,
        $id TEXT PRIMARY KEY,
        $employeeId TEXT NOT NULL )
      ''';
}