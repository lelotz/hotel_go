import 'dart:async';
import 'dart:io';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/data/local_storage/table_keys.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common/sqlite_api.dart';
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
    if(_database !=null) {
     // logger.i('database already initialized');
      return _database;
    }

    _database =  await _initiateDatabase();
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
    }

    return null;
  }


  /// Creates an sql Table by using an Sql Script
  Future<void> createTable(Database db, int version, String sqlScript)async
    {
    try {
      await db.execute(sqlScript);
    }catch (e){
      logger.e({'title':'CREATE-DB-ERROR','data':sqlScript},e.toString());
    }
  }
  /// Runs when the database is initially created
  ///
  /// This is where all the tables are created
  _onCreate(Database db, int version)async
    {
    await createAppTables(db, version);

    /// Adds Initial Data required to use the system
    loadInitData(initRoomData, initRoomStatus, initAdminUsers);

  }

  Future<void> createAppTables(Database db, int version) async {
    await Future.forEach(dbTablesSql, (sqlScript) async{
      await createTable(db, version, sqlScript);
    });
    // for(final sqlScript in dbTablesSql){
    //    await createTable(db, version, sqlScript);
    // }
  }

  /// Safely creates or inserts a row in an sql table
  /// This function will return a null value when an exception is caught
  ///
  /// [tableName] Refers to the table name. This value cannot be null
  ///
  /// [row] Refers to a Map object to be inserted in the table. This Map
  /// needs to have keys that match the table [tableName]'s column Names.
  Future<int> create(String tableName,Map<String,dynamic> row)async
    {
    int rowNumber = -1;
    Database? db = await instance.database;
    try{
      rowNumber = await db?.insert(tableName, row,conflictAlgorithm: ConflictAlgorithm.replace) ?? -1;
      //if(tableName == SessionTrackerTable.tableName) logger.i({'title': 'WRITE DB','data':row,'tableName': tableName});
    }catch(e){
      logger.e({'title': 'WRITE DB','data':row,'tableName': tableName},e.toString());
    }


    return rowNumber;
  }
  /// Safely queries data in an sql table [tableName]
  ///
  /// This function returns a future list of Map<String,dynamic> objects
  /// It will return a null value when an exception is caught
  ///
  /// [tableName] Refers to the table name. This value cannot be null
  ///
  /// [row] Refers to a Map object to be inserted in the table. This Map
  /// needs to have keys that match the table [tableName]'s column names.
  ///
  /// [where] Refers to the sql query parameters and conditions
  ///
  /// [whereArgs] Refers to the values of query parameters
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
    //await db?.close();

    return result;
  }
  /// This function was found to be redundant and is therefore deprecated.
  /// DO NOT USE
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
    //await db?.close();

    return result;
  }

  /// Safely updates data in an sql table [tableName]
  ///
  /// This function returns an int representing the row number of the updated [row]
  /// It will return a null value when an exception is caught
  ///
  /// [tableName] Refers to the table name. This value cannot be null
  ///
  /// [row] Refers to a Map object to be updated in the table. This Map
  /// needs to have keys that match the table [tableName]'s column names.
  ///
  /// [where] Refers to the sql query parameters and conditions
  ///
  /// [whereArgs] Refers to the values of query parameters
  Future<int?> update({
    required String tableName, required Map<String, Object?> row,
    required String where,required List<Object?> whereArgs})async
    {
    int? result;
    Database? db = await instance.database;
    try{
      result = await db?.update(tableName,row,where: where,whereArgs: whereArgs);
      //logger.i({'title': 'UPDATE DB','where':where,'whereArgs':whereArgs,'date': row,'response':result});
    }catch(e){
      logger.e({'title': 'UPDATE','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());
    }
    //await db?.close();

    return result;
  }

  /// Safely deletes data in an sql table [tableName]
  ///
  /// This function returns an int value representing the row number of the deleted row
  /// It will return a null value when an exception is caught
  ///
  /// [tableName] Refers to the table name. This value cannot be null
  ///
  /// [where] Refers to the sql query parameters and conditions
  ///
  /// [whereArgs] Refers to the values of query parameters
  Future<int> delete({required String tableName,
    String? where,List<Object?>? whereArgs,bool deleteAll = false})async
    {
    int result =-1;
    Database? db = await instance.database;
    try{
      result = deleteAll ? await db?.delete(tableName) ?? -1  : await db?.delete(tableName,where: where,whereArgs: whereArgs) ?? -1;
      //logger.i({'title': 'DELETE DB','where':where,'whereArgs':whereArgs,'response':result});
    }catch(e){
      logger.e({'title': 'DELETE DB','where':where,'whereArgs':whereArgs,'response':result,'tableName': tableName},e.toString());

    }
    //await db?.close();
    return result;
  }

  /// This function helps define whereArgs values in an sql string
  ///
  /// It is especially helpful when the amount of queries is unknown at runtime
  /// This scenario might happen when a user applies a number of filters in a search operation
  ///
  /// The function will create [n] amount of '?' symbols that represent an item in the [whereArgs]
  /// The '?' symbols are separated with [separator] which is ',' by default
  ///
  /// This function returns a string of [n] '?' separated with [separator]
  ///
  /// Example: '?,?,?' = buildNQuestionMarks(3,separator = ',')

  String buildNQuestionMarks(int n,{String separator = ','}){
    String whereString = '';
    String currentString = '?$separator';
    for(int i = 0; i < n;i++){
      currentString = i != n-1 ? '?$separator' : '?';
      whereString = whereString + currentString;
    }
    return whereString;
  }

  /// This function return a list of Object which is the base class of all Objects
  ///
  /// This function is useful if one of the [whereArgs] in query is a list
  /// Since the [whereArgs] of a query cannot contain a List as one of its values, this function allows you to
  /// deflate the list and have a whereArgs list of non-iterable values
  List<Object> buildWhereArgsFromList(List<Object> list){
    List<Object> whereArgs = [];
    for(Object arg in list){
      whereArgs.add(arg);
    }
    return whereArgs;
  }


}