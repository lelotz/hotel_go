
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';
import '../../models_n/collect_payment_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
class CollectedPaymentsRepository extends SqlDatabase{
  CollectedPaymentsRepository();
  SessionManager sessionManager = Get.find<SessionManager>();

  /// CollectedPayments CRUD
  Future<int?> createCollectedPayment(Map<String,dynamic> payment)async{
    int results = -1;
    await SqlDatabase.instance.create(CollectedPaymentsTable.tableName, payment).then((value) async{
      results = value;
      await SessionManagementRepository().createNewSessionActivity(
          SessionActivity(
            id: const Uuid().v1(),
            sessionId: sessionManager.currentSession.value.id,
            transactionId: payment[CollectedPaymentsTable.roomTransactionId],
            transactionType: payment[CollectedPaymentsTable.service]
      ).toJson()).then((value) {results = value ?? -1;});
    });
    return results;
  }
  Future<List<CollectPayment>?> getCollectedPaymentsByDate(String date)async{
    List<CollectPayment> payments= [];
    await SqlDatabase.instance.read(
        tableName:CollectedPaymentsTable.tableName,
        whereArgs: [date],
        where:'${CollectedPaymentsTable.date} = ?'
    ).then((value) {
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          payments.add(CollectPayment.fromJson(element));
        }
      }
    });

    return payments;
  }

  Future<List<CollectPayment>?> getCollectedPaymentsById(String collectedPaymentId)async{
    List<CollectPayment> payments= [];
    await SqlDatabase.instance.read(
        tableName:CollectedPaymentsTable.tableName,
        whereArgs: [collectedPaymentId],
        where:'${CollectedPaymentsTable.id} = ?'
    ).then((value) {
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> element in value){
          payments.add(CollectPayment.fromJson(element));
        }
      }
    });

    return payments;
  }

  Future<List<CollectPayment>> getMultipleCollectedPaymentsByIds(List<String> paymentIds,String transactionType)async{
    List<CollectPayment> payments= [];
    List<Object> whereArgs = [transactionType];
    whereArgs.addAll(buildWhereArgsFromList(paymentIds));

    await SqlDatabase.instance.read(
        tableName:CollectedPaymentsTable.tableName,
        whereArgs: whereArgs,
        where:'${CollectedPaymentsTable.service}=? AND ${CollectedPaymentsTable.roomTransactionId} IN (${buildNQuestionMarks(paymentIds.length)})'
    ).then((value) {
      payments = CollectPayment().fromJsonList(value ?? []);
    });

    return payments;
  }
}

/// Other Transactions Table
class CollectedPaymentsTable{
  static const String tableName = "collected_payments";
  static const String id = "id";
  static const String employeeName = "employeeName";
  static const String clientName = "clientName";
  static const String roomTransactionId = "roomTransactionId";
  static const String clientId = "clientId";
  static const String employeeId = "employeeId";
  static const String roomNumber = "roomNumber";
  static const String amountCollected = "amountCollected";
  static const String dateTime = "dateTime";
  static const String date = "date";
  static const String time ="time";
  static const String service ="service";
  static const String payMethod = "payMethod";
  static const String receiptNumber = "receiptNumber";


  String sql =
  '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $roomNumber INT NOT NULL,
    $service TEXT NOT NULL,
    $amountCollected INT NOT NULL,
    $date TEXT NOT NULL,
    $time TEXT NOT NULL,
    $payMethod TEXT NOT NULL,
    $receiptNumber TEXT,
    $employeeName TEXT NOT NULL,
    $clientName TEXT NOT NULL,
    $dateTime DATETIME NOT NULL,
    $id TEXT PRIMARY KEY,
    $clientId TEXT NOT NULL,
    $roomTransactionId TEXT ,
    $employeeId TEXT NOT NULL )
  ''';
}