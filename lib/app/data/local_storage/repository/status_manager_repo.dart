

import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class StatusManagerRepository extends SqlDatabase{
  StatusManagerRepository();

  Future<int?> createStatus(Map<String,dynamic> row)async{
    return await create(StatusManagerTable.tableName, row);
  }

  Future<List<Map<String, dynamic>>?> getStatusByType(String statusType)async{
    return await read(
      tableName: StatusManagerTable.tableName,
      where: '${StatusManagerTable.type}=?',
      whereArgs: [statusType]
    );
  }

}

class StatusManagerTable{
  static const String tableName = "status_manager";
  static const String id = "status_manager";
  static const String status = "status";
  static const String type = "type";

  String sql =
  '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $id TEXT PRIMARY KEY,
    $status TEXT NOT NULL,
    $type TEXT NOT NULL )
  ''';


}