import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/internl_transaction_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';

class InternalTransactionRepository extends SqlDatabase{
  InternalTransactionRepository();
  String tableName = InternalTransactionTable.tableName;

  Future<int?> createInternalTransaction(Map<String,dynamic> row)async{
    return await create(InternalTransactionTable.tableName, row);

  }

  Future<List<Map<String,dynamic>>?>? getInternalTransactionByDate(String date)async{
    return await read(
        tableName: tableName,where: '${InternalTransactionTable.dateTime} BETWEEN ? AND ?',
        whereArgs: [
          DateTime.parse(date).add(const Duration(days: -1)).toIso8601String(),
          DateTime.parse(date).add(const Duration(days: 1)).toIso8601String(),
        ]);
  }
  Future<List<InternalTransaction>>? getInternalTransactionByType(String type)async{
    List<InternalTransaction> results = [];
    await read(
        tableName: tableName,where: '${InternalTransactionTable.transactionType}=?',
        whereArgs: [type]).then((value) {
          if(value!=null && value.isNotEmpty){
            results = InternalTransaction().fromJsonList(value);
          }
    });
    return results;
  }

  Future<List<InternalTransaction>> getInternalTransactionById(String id)async{
    List<InternalTransaction> results = [];
    await read(
        tableName: tableName,where: '${InternalTransactionTable.id}=?',
        whereArgs: [id]).then((value) {
      if(value!=null && value.isNotEmpty){
        results = InternalTransaction().fromJsonList(value);
      }
    });
    return results;
  }

  Future<List<InternalTransaction>> getMultipleInternalTransactionByIds(List<String> transactionIds)async{
    List<InternalTransaction> results = [];
    List<Object> whereArgs = buildWhereArgsFromList(transactionIds);

    await read(
        tableName: tableName,where: '${InternalTransactionTable.id} IN (${buildNQuestionMarks(transactionIds.length)})',
        whereArgs: whereArgs).then((value) {
      if(value!=null && value.isNotEmpty){
        results = InternalTransaction().fromJsonList(value);
      }
    });
    return results;
  }

  Future<List<Map<String,dynamic>>?>? getAllInternalTransaction()async{
    return await read(
        tableName: tableName, readAll: true
    );
  }


}

class InternalTransactionTable{
  static const String tableName = "internal_transactions";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String beneficiaryName = "beneficiaryName";
  static const String beneficiaryId = "beneficiaryId";
  static const String description = "description";
  static const String transactionType = "transactionType";
  static const String transactionValue = "transactionValue";
  static const String dateTime = "dateTime";
  static const String department = "department";

  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $id TEXT PRIMARY KEY,
        $employeeId TEXT NOT NULL,
        $beneficiaryName TEXT NOT NULL,
        $beneficiaryId TEXT NOT NULL,
        $description TEXT NOT NULL,
        $transactionType TEXT NOT NULL,
        $transactionValue INT NOT NULL,
        $department TEXT NOT NULL,
        $dateTime DATETIME NOT NULL)
      ''';
}

