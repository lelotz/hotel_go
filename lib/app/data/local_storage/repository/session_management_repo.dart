
import 'package:get_storage/get_storage.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import '../../models_n/session_activity_model.dart';


class SessionManagementRepository  extends SqlDatabase{
  SessionManagementRepository();
  /// Session Tracker CRUD

  Future<int?> createNewSessionTracker(Map<String,dynamic> element)async{
    return await SqlDatabase.instance.create(
        SessionTrackerTable.tableName,
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

  Future<List<SessionTracker>> getSessionTracker(String sessionId,)async{
    List<SessionTracker> foundSessions = [];
    await read(
      tableName: SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.id}=?',
        whereArgs: [sessionId]
    ).then((value) {
      if(value !=null && value.isNotEmpty){
        foundSessions.addAll(SessionTracker().fromJsonList(value));
      }
    });
    return foundSessions;
  }

  Future<List<SessionTracker>> getAllSessionTrackers()async{
    List<SessionTracker> foundSessions = [];
    await read(
        tableName: SessionTrackerTable.tableName, readAll: true,
    ).then((value) {
      if(value !=null && value.isNotEmpty){
        foundSessions.addAll(SessionTracker().fromJsonList(value));
      }
    });
    return foundSessions;
  }

  Future<List<SessionTracker>> getSessionTrackersByEmployeeId({String? id})async{
    List<SessionTracker> foundSessions = [];
    await read(
      tableName: SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.employeeId}=?',
      whereArgs: [id]
    ).then((value) {
      foundSessions = SessionTracker().fromJsonList(value ?? []);
    });
    return foundSessions;
  }
  Future<List<SessionTracker>> getSessionByStatus(String sessionStatus)async{
    List<SessionTracker> foundSessions = [];
    await read(
        tableName: SessionTrackerTable.tableName,
        where:'${SessionTrackerTable.sessionStatus}=?',
      whereArgs: [sessionStatus]
    ).then((value) {
      if(value !=null && value.isNotEmpty){
        foundSessions.addAll(SessionTracker().fromJsonList(value));
      }
    });
    return foundSessions;
  }



  Future<List<Map<String, dynamic>>?> getSessionByEmployeeIdAndDate(String id,String date)async{
    List<Map<String, dynamic>>? session = [];

    DateTime dateOffset = DateTime.parse(date).add(const Duration(days: 1));
    await SqlDatabase.instance.read(
      tableName: SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.employeeId}=? AND ${SessionTrackerTable.dateCreated} BETWEEN ? AND ?',
      whereArgs: [id,DateTime.parse(date).add(const Duration(days: -1)).toIso8601String(),dateOffset.toIso8601String()],
    ).then((value) {
      session = value;

    });
    return session;
  }
  Future<List<Map<String, dynamic>>?> getSessionByEmployeeIdDateAndSessionStatus(String id,String date,String sessionStatus)async{
    List<Map<String, dynamic>>? session = [];

    DateTime dateOffset = DateTime.parse(date).add(const Duration(days: 1));
    await SqlDatabase.instance.read(
      tableName: SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.employeeId}=? AND ${SessionTrackerTable.sessionStatus}=? AND ${SessionTrackerTable.dateCreated} BETWEEN ? AND ?',
      whereArgs: [id,sessionStatus,DateTime.parse(date).add(const Duration(days: -1)).toIso8601String(),dateOffset.toIso8601String()],
    ).then((value) {
      session = value;

    });
    return session;
  }

  Future<List<SessionTracker>> getSessionByEmployeeIdAndSessionStatus(String id,String sessionStatus)async{
    List<SessionTracker> session = [];

    await SqlDatabase.instance.read(
      tableName: SessionTrackerTable.tableName,
      where: '${SessionTrackerTable.employeeId}=? AND ${SessionTrackerTable.sessionStatus}=? ',
      whereArgs: [id,sessionStatus],
    ).then((value) {
      if(value!=null && value.isNotEmpty){
        session = SessionTracker().fromJsonList(value);
      }

    });
    return session;
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

  Future<List<SessionActivity>> getSessionActivityByTransactionTypeAndSessionId(String transactionType,String sessionId)async{
    List<SessionActivity> result = [];
    await SqlDatabase.instance.read(
        tableName: SessionActivityTable.tableName,
        where: '${SessionActivityTable.transactionType}=? AND ${SessionActivityTable.sessionId}=?',
        whereArgs: [transactionType,sessionId]
    ).then((value) {
      result = SessionActivity().fromJsonList(value ?? []);
    });
    return result;
  }

  Future<List<SessionActivity>> getSessionActivityByTransactionTypeAndDateRange(String transactionType,String startDate,String endDate)async{
    List<SessionActivity> result = [];
    await SqlDatabase.instance.read(
        tableName: SessionActivityTable.tableName,
        where: '${SessionActivityTable.transactionType}=? AND ${SessionActivityTable.dateTime} BETWEEN ? AND ? ',
        whereArgs: [transactionType,startDate,endDate]
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
  static const String sessionStatus = "sessionStatus";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $id TEXT PRIMARY KEY,
       $employeeId TEXT NOT NULL,
       $dateCreated DATETIME NOT NULL,
       $sessionStatus TEXT NOT NULL,
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
  static const String dateTime = "dateTime";

  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
       $id TEXT PRIMARY KEY,
       $sessionId TEXT NOT NULL,
       $transactionId TEXT ,
       $dateTime TEXT NOT NULL,
       $transactionType TEXT NOT NULL )
      ''';
}

