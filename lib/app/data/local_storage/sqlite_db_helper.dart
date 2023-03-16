
import 'dart:async';
import 'dart:io';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_data_repository.dart';
import 'package:hotel_pms/app/data/local_storage/table_keys.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../core/logs/logger_instance.dart';
import 'innit_data.dart';


class SqlDatabase{
  Logger logger = AppLogger.instance.logger;
  static const _dbName = "whitemark_pms.db";
  static const _dbVersion = 1;

  SqlDatabase();
  SqlDatabase._privateConstruct();
  static final SqlDatabase instance = SqlDatabase._privateConstruct();
  var databaseFactory = databaseFactoryFfi;


  static Database? _database;
  Future<Database?> get database async
    {
    if(_database !=null) return _database;

    _database = await _initiateDatabase();
    return _database;

  }

  /// Initialize Database
  _initiateDatabase() async
    {
    try{
      Directory? directory = await FileManager().directoryPath;
      String path = join(directory!.path,_dbName);
      return await databaseFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
              version: _dbVersion,onCreate: _onCreate
          )
      );

    }catch(e){
      logger.e("INIT-DB-ERROR",e);
      //print("[INIT-DB-ERROR] $e");
    }

    return null;
  }



  Future<void> createTable(Database db, int version, String sqlScript)async
    {
    try {
      db.execute(sqlScript);
    }catch (e){
      logger.e({'title':'CREATE-DB-ERROR','data':sqlScript},e.toString());
    }
  }

  Future _onCreate(Database db, int version)async
    {
    for(final sqlScript in dbTablesSql){
      createTable(db, version, sqlScript);
    }

    loadInitData(initRoomData, initRoomStatus, initAdminUsers);
  }

  Future<int?> create(String tableName,Map<String,dynamic> row)async
    {
    int? rowNumber;
    Database? db = await instance.database;
    try{
      rowNumber = await db?.insert(tableName, row,conflictAlgorithm: ConflictAlgorithm.replace);
      logger.i({'title': 'WRITE DB','data':row,'tableName': tableName});
    }catch(e){
      logger.e({'title': 'WRITE DB','data':row,'tableName': tableName},e.toString());
    }

    return rowNumber;
  }

  Future<List<Map<String, dynamic>>?> read({
    String? tableName, String? where, List<Object?>? whereArgs,
    bool readAll = false,String? orderBy})async
    {
    List<Map<String,dynamic>>? result;
    Database? db = await instance.database;
    try{
      result =  readAll ? await db?.query(tableName!):
                          await db?.query(tableName!,where: where,whereArgs: whereArgs,orderBy: orderBy);
      //if(tableName! == RoomsTable.tableName){ logger.i({'title': 'READ DB','where':where,'whereArgs':whereArgs,'response':result,"tableName": tableName});}

    }catch(e){
      logger.e({'title': 'READ DB','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());
    }

    return result;
  }

  Future<List<Map<String, dynamic>>?> readMultipleRows({
    String? tableName, String? where, List<Object?>? whereArgs,
    bool readAll = false,String? orderBy})async
  {
    List<Map<String,dynamic>>? result;
    Database? db = await instance.database;
    try{
      result = await db?.query(tableName!,where: where,whereArgs: whereArgs,orderBy: orderBy);
      //logger.i({'title': 'READ DB','where':where,'whereArgs':whereArgs,'response':result});
    }catch(e){
      logger.e({'title': 'READ DB','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());
    }

    return result;
  }

  Future<int?> update({
    required String tableName, required Map<String, Object?> row,
    required String where,required List<Object?> whereArgs})async
    {
    int? result;
    Database? db = await instance.database;
    try{
      result = await db?.update(tableName,row,where: where,whereArgs: whereArgs);
      logger.i({'title': 'UPDATE DB','where':where,'whereArgs':whereArgs,'date': row,'response':result});
    }catch(e){
      logger.e({'title': 'UPDATE','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());
    }

    return result;
  }

  Future<int?> delete({required String tableName,
    required String where,required List<Object?> whereArgs})async
    {
    int? result;
    Database? db = await instance.database;
    try{
      result = await db?.delete(tableName,where: where,whereArgs: whereArgs);
      logger.i({'title': 'DELETE DB','where':where,'whereArgs':whereArgs,'response':result});
    }catch(e){
      logger.e({'title': 'DELETE DB','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());

    }
    return result;
  }

  String buildNQuestionMarks(int n,{String separator = ','}){
    String whereString = '';
    String currentString = '?$separator';
    for(int i = 0; i < n;i++){
      currentString = i != n-1 ? '?$separator' : '?';
      whereString = whereString + currentString;
    }
    return whereString;
  }

  List<Object> buildWhereArgsFromList(List<Object> list){
    List<Object> whereArgs = [];
    for(Object arg in list){
      whereArgs.add(arg);
    }
    return whereArgs;
  }


}