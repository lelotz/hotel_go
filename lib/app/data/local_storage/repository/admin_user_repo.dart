import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';

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
        where: '${AdminUsersTable.id} = ?',
        whereArgs: [row[AdminUsersTable.id]]
    );
    return response;
  }

  Future<String> getAdminUserNameById(String id)async{
    AdminUser adminUser = await getAdminUserById(id);

    if(adminUser.firstName!=null){
      return adminUser.fullName!;

    }

    return 'Not Found';
  }

  Future<AdminUser?> getAdminUserByName(String name)async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.fullName} = ?',
        whereArgs: [name]
    );

    return response == null || response.isEmpty ? AdminUser(): AdminUser().fromJsonList(response)[0] ;
  }

  Future<List<AdminUser>> getAllAdminUsers()async{
    List<Map<String, dynamic>>? response = await db.read(
        tableName: AdminUsersTable.tableName,
        readAll: true,
    );

    return AdminUser().fromJsonList(response ?? []);
  }
  Future<AdminUser> getAdminUserById(String id)async{
    AdminUser adminUser = AdminUser();
    await db.read(
        tableName: AdminUsersTable.tableName,
        where: '${AdminUsersTable.id} = ?',
        whereArgs: [id]
    ).then((value) {
      if(value!=null){
        adminUser = AdminUser().fromJsonList(value).first;
      }
    });
    return adminUser;
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

    String id = row[AdminUsersTable.id];
    int? rowId = await db.update(tableName: AdminUsersTable.tableName,
        row: row,where: '${AdminUsersTable.id} = ?',whereArgs: [id]
    );
    return rowId;
  }

}

/// Users Table
class AdminUsersTable{
  static const String tableName = "admin_users";
  static const String id = "id";
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
       
        $id TEXT PRIMARY KEY,
        $fullName TEXT NOT NULL,
        $firstName TEXT,
        $lastName TEXT,
        $position TEXT,
        $phone TEXT,
        $status TEXT,
        $roomsSold INT )
      ''';

}

