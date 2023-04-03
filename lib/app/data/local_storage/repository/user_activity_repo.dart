
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class UserActivityRepository extends SqlDatabase{

  UserActivityRepository();

  /// User Activity
  Future<int> createUserActivity(Map<String,dynamic> row,{String? tableName = UserActivityTable.tableName})async{
    int rowNumber = await create(tableName!, row);
    return rowNumber;
  }

  /// READ UserActivity
  Future<List<Map<String, dynamic>>?> getUserActivity(String roomTransactionId,{String? tableName = UserActivityTable.tableName})async{
    return await read(
        tableName: tableName,
        where: '${UserActivityTable.roomTransactionId} = ?',
        whereArgs: [roomTransactionId]
    );
  }
  Future<List<Map<String, dynamic>>?> getUserActivityByActivityId(String activityId,{String? tableName = UserActivityTable.tableName})async{
    return await read(
        tableName: tableName,
        where: '${UserActivityTable.activityId} = ?',
        whereArgs: [activityId]
    );
  }


}
class ReceivedPackagesTable{
  static const String tableName = "received_packages";
  static const String activityId = "activityId";
  static const String roomTransactionId = "roomTransactionId";
  static const String employeeId = "employeeId";
  static const String employeeFullName = "employeeFullName";
  static const String guestId = "guestId";
  static const String activityStatus = "activityStatus";
  static const String description = "description";
  static const String activityValue = "activityValue";
  static const String unit = "unit";
  static const String dateTime = "dateTime";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $activityId TEXT PRIMARY KEY,
       $roomTransactionId TEXT,
       $employeeId TEXT NOT NULL,
       $employeeFullName TEXT,
       $guestId TEXT NOT NULL,
       $activityStatus TEXT,
       $description TEXT NOT NULL,
       $activityValue INT,
       $unit TEXT NOT NULL,
       $dateTime TEXT NOT NULL )
      ''';
}

class ReturnedPackagesTable{
  static const String tableName = "returned_packages";
  static const String activityId = "activityId";
  static const String roomTransactionId = "roomTransactionId";
  static const String employeeId = "employeeId";
  static const String employeeFullName = "employeeFullName";
  static const String guestId = "guestId";
  static const String activityStatus = "activityStatus";
  static const String description = "description";
  static const String activityValue = "activityValue";
  static const String unit = "unit";
  static const String dateTime = "dateTime";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $activityId TEXT PRIMARY KEY,
       $roomTransactionId TEXT,
       $employeeId TEXT NOT NULL,
       $employeeFullName TEXT,
       $guestId TEXT NOT NULL,
       $activityStatus TEXT,
       $description TEXT NOT NULL,
       $activityValue INT,
       $unit TEXT NOT NULL,
       $dateTime TEXT NOT NULL )
      ''';
}
/// User Activity
class UserActivityTable{
  static const String tableName = "user_activity";
  static const String activityId = "activityId";
  static const String roomTransactionId = "roomTransactionId";
  static const String employeeId = "employeeId";
  static const String employeeFullName = "employeeFullName";
  static const String guestId = "guestId";
  static const String activityStatus = "activityStatus";
  static const String description = "description";
  static const String activityValue = "activityValue";
  static const String unit = "unit";
  static const String dateTime = "dateTime";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $activityId TEXT PRIMARY KEY,
       $roomTransactionId TEXT,
       $employeeId TEXT NOT NULL,
       $employeeFullName TEXT,
       $guestId TEXT NOT NULL,
       $activityStatus TEXT,
       $description TEXT NOT NULL,
       $activityValue INT,
       $unit TEXT NOT NULL,
       $dateTime TEXT NOT NULL )
      ''';
}