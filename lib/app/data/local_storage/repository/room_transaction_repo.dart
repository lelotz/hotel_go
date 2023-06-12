import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';


class RoomTransactionRepository extends SqlDatabase {
  /// Room Transactions CRUD
  RoomTransactionRepository();

  /// Create RoomTransaction
  Future<int?> createRoomTransaction(Map<String, dynamic> row) async {
    int? rowNumber = await create(RoomTransactionsTable.tableName, row);
    String employeeName = await AdminUserRepository().getAdminUserNameById(row[RoomTransactionsTable.employeeId]);
    await UserActivityRepository().createUserActivity(
        UserActivity(
            activityId: const Uuid().v1(),
            activityValue: row[RoomTransactionsTable.amountPaid],
            activityStatus: LocalKeys.kRoom,
            description: LocalKeys.kCheckIn,
            guestId: row[RoomTransactionsTable.clientId],
            unit: LocalKeys.kRoom,
            employeeId: row[RoomTransactionsTable.employeeId],
            employeeFullName: employeeName,
            dateTime: DateTime.now().toIso8601String(),
            roomTransactionId: row[RoomTransactionsTable.id]
        ).toJson());
    return rowNumber;
  }

  /// READ RoomTransaction by id
  Future<RoomTransaction> getRoomTransaction(
      String roomTransactionId) async {
    RoomTransaction roomTransaction = RoomTransaction();
     await read(
        tableName: RoomTransactionsTable.tableName,
        where: '${RoomTransactionsTable.id} = ?',
        whereArgs: [roomTransactionId]).then((value) {
          if(value!=null && value.isNotEmpty){
            roomTransaction = RoomTransaction.fromJson(value.first);
          }
     });
    return roomTransaction;
  }

  /// READ RoomTransaction by id
  Future<List<RoomTransaction>> getMultipleRoomTransactions(
      List<String> roomTransactionIds) async {
    List<RoomTransaction> result = [];
    await read(
            tableName: RoomTransactionsTable.tableName,
            where:
                '${RoomTransactionsTable.id} IN (${buildNQuestionMarks(roomTransactionIds.length)})',
            whereArgs: buildWhereArgsFromList(roomTransactionIds))
        .then((value) {
      result = RoomTransaction().fromJsonList(value ?? []);
    });
    return result;
  }

  /// READ RoomTransaction by id
  Future<List<RoomTransaction>> getAllRoomTransactions() async {
    List<RoomTransaction> result = [];
    await read(tableName: RoomTransactionsTable.tableName,readAll: true)
        .then((value) {
      result = RoomTransaction().fromJsonList(value ?? []);
    });
    return result;
  }
  Future<List<RoomTransaction>> getRoomTransactionsByEmployeeId({String? id})async{
    List<RoomTransaction> result = [];
    if(id!=null){
      await read(
          tableName: RoomTransactionsTable.tableName,
          where:
          '${RoomTransactionsTable.employeeId}=?',
          whereArgs: [id])
          .then((value) {
        result.addAll(RoomTransaction().fromJsonList(value ?? []));
      });
    }
    return result;
  }

  /// READ RoomTransactions by given filters
  Future<List<Map<String, dynamic>>?> getFilteredRoomTransactions(
      {required String where, required List<dynamic> whereArgs}) async {
    return await read(
        tableName: RoomTransactionsTable.tableName,
        where: where,
        whereArgs: whereArgs);
  }

  Future<int?> updateRoomTransaction(Map<String, dynamic> row,{String? updateDetails,String? unit,bool createUserActivity=false}) async {
    String id = row[RoomTransactionsTable.id];
    int? rowId = await update(
        tableName: RoomTransactionsTable.tableName,
        row: row,
        where: '${RoomTransactionsTable.id} = ?',
        whereArgs: [id]);
    if(createUserActivity) {
      await UserActivityRepository().createUserActivity(UserActivity(
          activityId: const Uuid().v1(),
          activityValue: 0,
          activityStatus: updateDetails ?? '',
          description: updateDetails,
          unit: unit ?? '',
          roomTransactionId: row[RoomTransactionsTable.id],
          employeeId: Get.find<AuthController>().adminUser.value.id,
          employeeFullName: Get.find<AuthController>().adminUser.value.fullName,
          guestId: row[RoomTransactionsTable.clientId],
          dateTime: DateTime.now().toIso8601String(),

      ).toJson());
    }
    return rowId;
  }
}

/// Room Transactions Table
class RoomTransactionsTable {
  static const String tableName = "room_transactions";
  static const String id = "id";
  static const String clientId = "clientId";
  static const String sessionId = "sessionId";

  static const String employeeId = "employeeId";
  static const String roomNumber = "roomNumber";
  static const String amountPaid = "amountPaid";
  static const String outstandingBalance = "outstandingBalance";
  static const String paymentNotes = "paymentNotes";
  static const String transactionNotes = "transactionNotes";
  static const String date = "date";
  static const String time = "time";
  static const String checkInDate = "checkInDate";
  static const String checkOutDate = "checkOutDate";
  static const String nights = "nights";
  static const String roomCost = "roomCost";
  static const String arrivingFrom = "arrivingFrom";
  static const String goingTo = "goingTo";
  static const String grandTotal = "grandTotal";
  static const String otherCosts = "otherCosts";
  static const String roomAmountPaid = "roomAmountPaid";
  static const String roomOutstandingBalance = "roomOutstandingBalance";
  String sql = '''
        CREATE TABLE IF NOT EXISTS $tableName(
        $roomNumber INT NOT NULL,
        $nights INT NOT NULL,
        $roomCost INT NOT NULL,
        $roomAmountPaid INT NOT NULL,
        $roomOutstandingBalance INT NOT NULL,
        $otherCosts INT,
        $amountPaid INT NOT NULL,
        $grandTotal INT NOT NULL,
        $outstandingBalance INT NOT NULL,
        $paymentNotes TEXT,
        $transactionNotes TEXT,
        $id TEXT PRIMARY KEY,
        $clientId TEXT NOT NULL,
        $employeeId TEXT NOT NULL,
        $date TEXT NOT NULL,
        $time TEXT NOT NULL,
        $checkInDate INT NOT NULL,
        $checkOutDate INT NOT NULL,
        $arrivingFrom TEXT NOT NULL,
        $sessionId TEXT,
        $goingTo TEXT NOT NULL )
      ''';
}
