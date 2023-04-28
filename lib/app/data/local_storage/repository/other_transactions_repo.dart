

import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class OtherTransactionsRepository extends SqlDatabase{
  OtherTransactionsRepository();
  /// Other Transaction
  Future<int?> createOtherTransaction(Map<String,dynamic> row)async{
    int? rowNumber = await create(OtherTransactionsTable.tableName, row).then((value) async{
      SessionManagementRepository().createNewSessionActivity(
          SessionActivity(
            id: Uuid().v1(),
            sessionId: Get.find<AuthController>().sessionController.currentSession.value.id,
            transactionId: row[OtherTransactionsTable.id],
            transactionType: row[OtherTransactionsTable.paymentNotes],
            dateTime: DateTime.now().toIso8601String()
          ).toJson());
    });
    return rowNumber;
  }

  /// READ OtherTransaction
  Future<List<Map<String, dynamic>>?> getOtherTransaction(String roomTransactionId)async{
    return await read(
        tableName: OtherTransactionsTable.tableName,
        where: '${OtherTransactionsTable.roomTransactionId} = ?',
        whereArgs: [roomTransactionId]
    );
  }

  /// READ OtherTransaction
  Future<List<OtherTransactions>> getMultipleOtherTransaction(List<String> ids)async{
    List<OtherTransactions> result = [];
     await read(
        tableName: OtherTransactionsTable.tableName,
        where: '${OtherTransactionsTable.id} IN (${buildNQuestionMarks(ids.length)})',
        whereArgs: buildWhereArgsFromList(ids)
    ).then((value) {
      result = OtherTransactions().fromJsonList(value ?? []);
     });
     return result;
  }
  /// UPDATE OtherTransaction
  Future<int?> updateOtherTransaction(Map<String,dynamic> row) async{
    String id = row[OtherTransactionsTable.id];
    int? rowId = await update(tableName: OtherTransactionsTable.tableName,
        row: row,where: '${OtherTransactionsTable.id} = ?',whereArgs: [id]
    );
    return rowId;
  }

  Future<List<OtherTransactions>> getOtherTransactionsByEmployeeId({String? appId,String? id})async{
    List<OtherTransactions> result = [];

    await read(
      tableName: OtherTransactionsTable.tableName,
      where: '${OtherTransactionsTable.employeeId}=? OR ${OtherTransactionsTable.employeeId}=?',
      whereArgs: [appId,id]
    ).then((value) {
      result = OtherTransactions().fromJsonList(value ?? []);
    });

    return result;
  }

}

/// Other Transactions Table
class OtherTransactionsTable{
  static const String tableName = "other_transactions";
  static const String id = "id";
  static const String roomTransactionId = "roomTransactionId";
  static const String clientId = "clientId";
  static const String employeeId = "employeeId";
  static const String roomNumber = "roomNumber";
  static const String amountPaid = "amountPaid";
  static const String outstandingBalance = "outstandingBalance";
  static const String transactionNotes ="transactionNotes";
  static const String paymentNotes = "paymentNotes";
  static const String dateTime = "dateTime";
  static const String grandTotal = "grandTotal";

  String sql =
  '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $roomNumber INT NOT NULL,
    $amountPaid INT NOT NULL,
    $grandTotal INT NOT NULL,
    $outstandingBalance INT NOT NULL,
    $transactionNotes TEXT NOT NULL,
    $paymentNotes TEXT NOT NULL,
    $dateTime TEXT NOT NULL,
    $id TEXT PRIMARY KEY,
    $clientId TEXT NOT NULL,
    $roomTransactionId TEXT NOT NULL,
    $employeeId TEXT NOT NULL )
  ''';
}