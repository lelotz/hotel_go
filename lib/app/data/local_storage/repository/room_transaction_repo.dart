
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import '../table_keys.dart';

class RoomTransactionRepository extends SqlDatabase{
    /// Room Transactions CRUD
    RoomTransactionRepository();
    /// Create RoomTransaction
    Future<int?> createRoomTransaction(Map<String,dynamic> row)async{
      int? rowNumber = await create(RoomTransactionsTable.tableName, row);
      return rowNumber;
    }
    /// READ RoomTransaction by id
    Future<List<Map<String, dynamic>>?> getRoomTransaction(String roomTransactionId)async{
      return await read(
          tableName: RoomTransactionsTable.tableName,
          where: '${RoomTransactionsTable.id} = ?',
          whereArgs: [roomTransactionId]
      );
    }

    /// READ RoomTransaction by id
    Future<List<RoomTransaction>> getMultipleRoomTransactions(List<String> roomTransactionIds)async{
      List<RoomTransaction> result = [];
      await read(
          tableName: RoomTransactionsTable.tableName,
          where: '${RoomTransactionsTable.id} IN (${buildNQuestionMarks(roomTransactionIds.length)})',
          whereArgs: buildWhereArgsFromList(roomTransactionIds)
      ).then((value) {
        result = RoomTransaction().fromJsonList(value ?? []);
      });
      return result;
    }


    /// READ RoomTransactions by given filters
    Future<List<Map<String, dynamic>>?> getFilteredRoomTransactions(
        {required  String where,required  List<dynamic> whereArgs})async{
      return await read(
          tableName: RoomTransactionsTable.tableName,
          where: where,
          whereArgs: whereArgs
      );
    }

    Future<int?> updateRoomTransaction(Map<String,dynamic> row) async{
      String id = row[RoomTransactionsTable.id];
      int? rowId = await update(tableName: RoomTransactionsTable.tableName,
          row: row,where: '${RoomTransactionsTable.id} = ?',whereArgs: [id]
      );
      return rowId;
    }
}

/// Room Transactions Table
class RoomTransactionsTable{
  static const String tableName = "room_transactions";
  static const String id = "id";
  static const String clientId = "clientId";
  static const String employeeId = "employeeId";
  static const String roomNumber = "roomNumber";
  static const String amountPaid = "amountPaid";
  static const String outstandingBalance = "outstandingBalance";
  static const String paymentNotes = "paymentNotes";
  static const String transactionNotes ="transactionNotes";
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
  String sql =
  '''
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
        $goingTo TEXT NOT NULL )
      ''';
}
