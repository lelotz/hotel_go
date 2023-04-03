
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';


class RoomStatusRepository{
  SqlDatabase db = SqlDatabase.instance;
  RoomStatusRepository();
  /// Room Status CRUD

  /// CREATE RoomStatus
  Future<int?> createRoomStatus(Map<String,dynamic> row)async{
    int? rowNumber = await db.create(RoomStatusTable.tableName, row);
    return rowNumber;
  }

  /// READ RoomStatus
  Future<List<Map<String, dynamic>>?> getAllRoomsStatus()async{
    return await db.read(
        tableName: RoomStatusTable.tableName,
        readAll: true
    );
  }
  /// READ RoomStatus by proving roomNumber
  Future<List<Map<String, dynamic>>?> getRoomsStatus(int roomId)async{
    return await db.read(
        tableName: RoomStatusTable.tableName,
        where: '${RoomStatusTable.roomId} = ?',
        whereArgs: [roomId.toString()]
    );
  }

  /// Update ROOM Status
  Future<int?> updateRoomStatus(Map<String,dynamic> row) async{
    int id = row[RoomStatusTable.roomId];
    int? rowId = await db.update(tableName: RoomStatusTable.tableName,
        row: row,where: '${ RoomStatusTable.roomId} = ?',whereArgs: [id]
    );
    return rowId;
  }
}

/// Room Status Table
class RoomStatusTable{
  static const String tableName = "room_status";
  static const String roomId = "roomId";
  static const String code = "code";
  static const String description = "description";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $roomId INT PRIMARY KEY,
        $code TEXT NOT NULL,
        $description TEXT NOT NULL )
      ''';
}