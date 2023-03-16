
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

import '../table_keys.dart';

class ClientUserRepository extends SqlDatabase{
  ClientUserRepository();
  /// CREATE
  Future<int?> createClientUser(Map<String,dynamic> row)async{
    int? rowNumber = await create(ClientTable.tableName, row);
    return rowNumber;
  }

  /// READ
  Future<List<Map<String, dynamic>>?> getClientUser(String userId)async{
    List<Map<String, dynamic>>? response = await read(
        tableName: ClientTable.tableName,
        where: '${ClientTable.clientId} = ?',
        whereArgs: [userId]
    );
    return response;
  }
}
/// Client Table
class ClientTable{
  static const String tableName = "clients";
  static const String clientId = "clientId";
  static const String fullName = "fullName";
  static const String lastName = "lastName";
  static const String firstName = "firstName";
  static const String idType = "idType";
  static const String idNumber = "idNumber";
  static const String countryOfBirth = "countryOfBirth";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
      $clientId TEXT PRIMARY KEY,
      $fullName TEXT NOT NULL,
      $firstName TEXT,
      $lastName TEXT,
      $idType TEXT,
      $idNumber TEXT,
      $countryOfBirth TEXT )
      ''';
}