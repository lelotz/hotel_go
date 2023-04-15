import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';

class UserActivityRepository extends SqlDatabase {
  UserActivityRepository();

  /// User Activity
  Future<int> createUserActivity(Map<String, dynamic> row,
      {String? tableName = UserActivityTable.tableName}) async {
    int rowNumber = await create(tableName!, row);
    return rowNumber;
  }

  /// READ UserActivity
  Future<List<Map<String, dynamic>>?> getUserActivity(String roomTransactionId,
      {String? tableName = UserActivityTable.tableName}) async {
    return await read(
        tableName: tableName,
        where: '${UserActivityTable.roomTransactionId} = ?',
        whereArgs: [roomTransactionId]);
  }

  Future<List<Map<String, dynamic>>?> getUserActivityByActivityId(
      String activityId,
      {String? tableName = UserActivityTable.tableName}) async {
    return await read(
        tableName: tableName,
        where: '${UserActivityTable.activityId} = ?',
        whereArgs: [activityId]);
  }

  Future<List<UserActivity>> getUserActivityByDescription(
      String description,
      {String? tableName = UserActivityTable.tableName}) async {
    List<UserActivity> userActivity = [];
    await read(
        tableName: tableName,
        where: '${UserActivityTable.description} = ?',
        whereArgs: [description]).then((value) {
          userActivity = UserActivity.fromJsonList(value?? []);
    });

    return userActivity;
  }

  Future<List<UserActivity>> getUserActivityByRoomTransactionId(
      String roomTransactionId,
      {String? tableName = UserActivityTable.tableName}) async {
    List<UserActivity> userActivity = [];
    await read(
        tableName: tableName,
        where: '${UserActivityTable.roomTransactionId} = ?',
        whereArgs: [roomTransactionId]).then((value) {
      userActivity = UserActivity.fromJsonList(value?? []);
    });

    return userActivity;
  }
  Future<List<UserActivity>> getUserActivityByRoomTransactionIdAndDescription(
      String roomTransactionId,String description,
      {String? tableName = UserActivityTable.tableName}) async {
    List<UserActivity> userActivity = [];
    await read(
        tableName: tableName,
        where: '${UserActivityTable.roomTransactionId} = ? AND ${UserActivityTable.description} = ?',
        whereArgs: [roomTransactionId,description]).then((value) {
      userActivity = UserActivity.fromJsonList(value?? []);
    });

    return userActivity;
  }
  Future<int> deleteUserActivity(Map<String, dynamic> row,
      {String? tableName = UserActivityTable.tableName}) async {
    int rowNumber = await delete(
        tableName: tableName!,
        where: '${UserActivityTable.activityId}=?',
        whereArgs: [row[UserActivityTable.activityId]]
    );
    return rowNumber;
  }
}

class ReceivedPackagesTable {
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
  String sql = '''
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

class ReturnedPackagesTable {
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
  String sql = '''
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
class UserActivityTable {
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
  String sql = '''
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
