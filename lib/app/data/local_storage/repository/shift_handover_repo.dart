

import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class ShiftHandOverRepository extends SqlDatabase{
  ShiftHandOverRepository();

  Future<int?> createShiftHandOverRecord(Map<String,dynamic> row) async{
    return await create(ShiftHandOverTable.tableName, row);
  }
}

class ShiftHandOverTable{
  static const String tableName = "shift_handover";
  static const String id = "id";
  static const String incomingEmployeeId = "incomingEmployeeId";
  static const String outgoingEmployeeId = "outgoingEmployeeId";
  static const String dateTime = "dateTime";

  String sql =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id TEXT PRIMARY KEY,
  $incomingEmployeeId TEXT NOT NULL,
  $outgoingEmployeeId TEXT,
  $dateTime DATETIME NOT NULL )
  ''';






}