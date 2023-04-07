import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class AdminUserRepository{
  SqlDatabase db = SqlDatabase.instance;
  AdminUserRepository();
  // CREATE
  Future<int?> createAdminUser(Map<String,dynamic> row)async{
    int? rowNumber = await db.create(AdminUsersTable.tableName, row);
    return rowNumber;
  }

  // READ

  Future<List<Map<String, dynamic>>?> getAdminUser(Map<String,dynamic> row)async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.appId} = ?',
        whereArgs: [row[AdminUsersTable.appId]]
    );
    return response;
  }
  Future<List<Map<String, dynamic>>?> getAdminUserByName(String name)async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.fullName} = ?',
        whereArgs: [name]
    );
    return response;
  }
  Future<List<Map<String, dynamic>>?> getAdminUserById(String id)async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.appId} = ?',
        whereArgs: [id]
    );
    return response;
  }
  Future<List<Map<String, dynamic>>?> getAdminUserByPosition(String position)async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.position} = ?',
        whereArgs: [position]
    );
    return response;
  }


  Future<int?> updateAdminUser(Map<String,dynamic> row) async{

    String id = row[AdminUsersTable.appId];
    int? rowId = await db.update(tableName: AdminUsersTable.tableName,
        row: row,where: '${AdminUsersTable.appId} = ?',whereArgs: [id]
    );
    return rowId;
  }

}

/// Users Table
class AdminUsersTable{
  static const String tableName = "admin_users";
  static const String appId = "appId";
  static const String fullName = "fullName";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String position = "position";
  static const String phone = "phone";
  static const String roomsSold = "roomsSold";
  static const String status = "status";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $appId TEXT PRIMARY KEY,
        $fullName TEXT NOT NULL,
        $firstName TEXT,
        $lastName TEXT,
        $position TEXT,
        $phone TEXT,
        $status TEXT,
        $roomsSold INT )
      ''';

}

