import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../core/logs/logger_instance.dart';
import '../../../data/local_storage/repository/room_data_repository.dart';
import '../../../data/models_n/room_data_model.dart';

class HomepageController extends GetxController{
  Rx<List<RoomData>> roomData = Rx<List<RoomData>>([]);
  Rx<int> roomDataCount = Rx<int>(0);
  Rx<RoomData> selectedRoomData = Rx<RoomData>(RoomData());
  Logger logger = AppLogger.instance.logger;

  ///Rx<List<String>> authorizedRoutes =

  @override
  Future<void> onInit()async {
    await loadRoomData();


    //Get.find<LocalizationController>().refreshData();

    super.onInit();
  }

  // @override
  // void onDelete(){
  //   super.onDelete();
  // }

  loadRoomData()async{
    roomData.value.clear();
    roomData.value = await RoomDataRepository().getAllRoomData();
    roomDataCount.value = roomData.value.length;
    roomDataCount.refresh();
    //logger.wtf({'Room Data loaded':roomData.value.length});
  }

  Future<void> refreshSelectedRoom()async{
    await loadRoomData();
    selectedRoomData.value = await RoomDataRepository().getRoom(selectedRoomData.value.roomNumber!);
  }

  selectedRoom(RoomData room){
    selectedRoomData.value = room;
    //logger.i({'Selected Room' : selectedRoomData.value.roomNumber,'status': selectedRoomData.value.roomStatus!.description });
    //print('ROOM DATA : ${selectedRoomData.value.roomNumber}');
  }


}