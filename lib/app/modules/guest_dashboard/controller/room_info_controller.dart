import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_data_repository.dart';
import 'package:hotel_pms/app/data/models_n/room_data_model.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/localization/local_keys.dart';

class RoomInfoController extends GetxController{

  Logger logger  = AppLogger.instance.logger;
  Rx<List<String>> availableRooms = Rx<List<String>>([]);
  Rx<List<String>> occupiedRooms = Rx<List<String>>([]);
  Rx<List<String>> outOfServiceRooms = Rx<List<String>>([]);
  Rx<List<String>> allRooms = Rx<List<String>>([]);

  @override
  Future<void> onInit()async{
    super.onInit();
    await getRoomInfo();
  }

  void clearData(){
    allRooms.value.clear();
    availableRooms.value.clear();
    occupiedRooms.value.clear();
    outOfServiceRooms.value.clear();
  }

  Future<void> getRoomInfo()async{
    clearData();
    await RoomDataRepository().getAllRoomData().then((value) {
      if(value.isNotEmpty){
        for(RoomData roomData in value){
          allRooms.value.add(roomData.roomNumber.toString());
          sortRoomInfo(roomData);
        }
      }
    });
    logger.i({"roomsFound": allRooms.value.length});
  }

  void sortRoomInfo(RoomData currentRoom){
    switch (currentRoom.roomStatus!.description){
      case LocalKeys.kOccupied :
        {
          occupiedRooms.value.add(currentRoom.roomNumber.toString());
          break;
        }
      case LocalKeys.kAvailable :
        {
          availableRooms.value.add(currentRoom.roomNumber.toString());
          break;
        }
      case LocalKeys.kOutOfOrder :
        {
          outOfServiceRooms.value.add(currentRoom.roomNumber.toString());
          break;
        }
      default: logger.e({'SortingRoomInfo': 'roomStatus not found','status': currentRoom.roomStatus});

    }
  }


}