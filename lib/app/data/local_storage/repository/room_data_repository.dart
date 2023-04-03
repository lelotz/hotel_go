
import 'package:hotel_pms/app/data/local_storage/repository/room_status_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/room_data_model.dart';
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';


class RoomDataRepository {

  SqlDatabase db = SqlDatabase.instance;
  RoomDataRepository();


  /// CREATE
  Future<int?> createRoom(Map<String,dynamic> row)async{
    int rowNumber = await db.create(RoomsTable.tableName, row);
    return rowNumber;
  }

  /// READ
  /// READ All [ROOMS]
  Future<List<Map<String, dynamic>>?> getAllRooms()async{
    return await db.read(tableName: RoomsTable.tableName,readAll: true);
  }




  Future<List<RoomData>> getAllRoomData()async{
    List<RoomData> roomData = [];
    await db.read(tableName: RoomsTable.tableName,readAll: true).then((value) async{
      if(value != null && value.isNotEmpty){
        for(Map<String,dynamic> room in value){
          RoomData currentRoom = RoomData.fromJson(room);
          await RoomStatusRepository().getRoomsStatus( currentRoom.roomNumber ?? 0).then((value) {
            if(value != null && value.isNotEmpty) {
              currentRoom.roomStatus = RoomStatusModel.fromJson(value[0]);
              roomData.add(currentRoom);
            }
          });
          //roomData.add(RoomData.fromJson(room));
        }
      }
    });
    return roomData;
  }

  /// READ [ROOMS] by [roomNumber]
  Future<RoomData> getRoom(int roomNumber)async{
    RoomData room = RoomData();
    await db.read(
        tableName: RoomsTable.tableName,
        where: '${RoomsTable.id} = ?',
        whereArgs: [roomNumber]
    ).then((value) async{
      if(value!=null && value.isNotEmpty){
        room = RoomData.fromJson(value[0]);
        await RoomStatusRepository().getRoomsStatus(room.roomNumber ?? 0).then((value) {
          if(value != null && value.isNotEmpty) {
            room.roomStatus = RoomStatusModel.fromJson(value[0]);
          }
        });
      }
    });
    return room;
  }
  /// UPDATE ROOM
  Future<int?> updateRoom(Map<String,dynamic> row) async{


    int id = row[RoomsTable.id];
    int? rowId = await db.update(tableName: RoomsTable.tableName,
        row: row,where: '${RoomsTable.id} = ?',whereArgs: [id]
    );
    return rowId;
  }

}

/// Rooms Table
class RoomsTable{
  static const String tableName = "rooms";
  static const String id = "roomNumber";
  static const String isVIP = "isVIP";
  static const String currentTransactionId = "currentTransactionId";
  static const String nextAvailableDate = "nextAvailableDate";
  String sql =
  '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $id INT PRIMARY KEY,
        $isVIP  INT NOT NULL,
        $currentTransactionId TEXT,
        $nextAvailableDate DATETIME )
      ''';
}

