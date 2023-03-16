
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import '../../models_n/session_activity_model.dart';


class SessionManagementRepository  extends SqlDatabase{
  SessionManagementRepository();
  /// Session Tracker CRUD

  Future<int?> createNewSessionTracker(Map<String,dynamic> element, {bool currentSession = false})async{
    return await SqlDatabase.instance.create(
        currentSession ? CurrentSessionTable.tableName : SessionTrackerTable.tableName,
        element
    );
  }

  Future<int?> updateSessionTracker(Map<String,dynamic> element)async{
    return await SqlDatabase.instance.update(
        tableName: SessionTrackerTable.tableName,
        row: element,
        where: '${SessionTrackerTable.id} = ?',
        whereArgs: [element[SessionTrackerTable.id]]
    );
  }

  Future<List<Map<String, dynamic>>?> getSessionByEmployeeIdAndDate(String id,String date,  {bool currentSession = false})async{
    List<Map<String, dynamic>>? session = [];

    DateTime dateOffset = DateTime.parse(date).add(const Duration(days: 1));
    await SqlDatabase.instance.read(
      tableName: currentSession ? CurrentSessionTable.tableName : SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.employeeId}=? AND ${SessionTrackerTable.dateCreated} BETWEEN ? AND ?',
      whereArgs: [id,DateTime.parse(date).add(const Duration(days: -1)).toIso8601String(),dateOffset.toIso8601String()],
    ).then((value) {
      session = value;

    });
    return session;
  }

  Future<int?> deleteCurrentSession(String userId)async{
    return await SqlDatabase.instance.delete(
        tableName: CurrentSessionTable.tableName,
        where: '${CurrentSessionTable.employeeId}=?',
        whereArgs: [userId]
    );

  }

  /// Session Activity

  Future<int?> createNewSessionActivity(Map<String,dynamic> element)async{
    return await SqlDatabase.instance.create(SessionActivityTable.tableName, element);
  }

  Future<List<SessionActivity>> getSessionStorageBySessionId(String id)async{
    List<SessionActivity> sessionStore = [];

    await SqlDatabase.instance.read(
        tableName: SessionActivityTable.tableName,
        where: '${SessionActivityTable.sessionId}=?',
        whereArgs: [id]
    ).then((value) {
      if(value!=null) sessionStore = SessionActivity().fromJsonList(value);
    });

    return sessionStore;
  }

  Future<List<SessionActivity>> getSessionActivityByTransactionType(String transactionType)async{
    List<SessionActivity> result = [];
    await SqlDatabase.instance.read(
      tableName: SessionActivityTable.tableName,
      where: '${SessionActivityTable.transactionType}=?',
      whereArgs: [transactionType]
    ).then((value) {
      result = SessionActivity().fromJsonList(value ?? []);
    });
    return result;
  }
}


/// Session Tracker Table
class SessionTrackerTable{
  static const String tableName = "session_tracker";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String dateCreated = "dateCreated";
  static const String dateEnded = "dateEnded";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $id TEXT PRIMARY KEY,
       $employeeId TEXT NOT NULL,
       $dateCreated DATETIME NOT NULL,
       $dateEnded DATETIME )
      ''';
}

/// Session Tracker Table
class SessionActivityTable{
  static const String tableName = "session_activity";
  static const String id = "id";
  static const String sessionId = "sessionId";
  static const String transactionId = "transactionId";
  static const String transactionType = "transactionType";

  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $id TEXT PRIMARY KEY,
       $sessionId TEXT NOT NULL,
       $transactionId TEXT ,
       $transactionType TEXT NOT NULL )
      ''';
}

/// Session Tracker Table
class CurrentSessionTable{
  static const String tableName = "current_session";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String dateCreated = "dateCreated";
  static const String dateEnded = "dateEnded";

  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $id TEXT PRIMARY KEY,
       $employeeId TEXT NOT NULL,
       $dateCreated DATETIME NOT NULL,
       $dateEnded DATETIME )
      ''';
}