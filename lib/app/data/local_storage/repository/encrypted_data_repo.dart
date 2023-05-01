

import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/encrypted_data_model.dart';

class EncryptedDataRepository {
  SqlDatabase db = SqlDatabase.instance;
  EncryptedDataRepository();

  Future<List<EncryptedData>> getEncryptedDataByUserId(String userId)async{
    List<EncryptedData> result = [];
   await db.read(
      tableName: EncryptedDataTable.tableName,
      where: '${EncryptedDataTable.userId}=?',whereArgs: [userId]
    ).then((value) {
      result = EncryptedData().fromJsonList(value??[]);

   });
   return result;
  }
  Future<int?> createEncryptedData(Map<String,dynamic> row)async{
    return await db.create(EncryptedDataTable.tableName, row);
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