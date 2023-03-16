

import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class EncryptedDataRepository extends SqlDatabase{
  EncryptedDataRepository();

  Future<List<Map<String, dynamic>>?> getEncryptedDataByUserId(String userId)async{
    return await read(
      tableName: EncryptedDataTable.tableName,
      where: '${EncryptedDataTable.userId}=?',whereArgs: [userId]
    );
  }
  Future<int?> createEncryptedData(Map<String,dynamic> row)async{
    return create(EncryptedDataTable.tableName, row);
  }

}



/// EncryptedDataTable
class EncryptedDataTable{
  static const String tableName = "encrypted_data";
  static const String userId = "userId";
  static const String data = "data";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $userId TEXT PRIMARY KEY,
        $data TEXT NOT NULL )
      ''';

}