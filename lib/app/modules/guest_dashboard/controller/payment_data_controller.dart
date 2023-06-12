import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';

import '../../../data/local_storage/repository/room_transaction_repo.dart';
import '../../../data/models_n/room_data_model.dart';
import '../../homepage_screen/controller/homepage_controller.dart';

class PaymentDataController extends GetxController{
  RoomData get selectedRoom => Get.find<HomepageController>().selectedRoomData.value;
  Rx<RoomTransaction> roomTransaction = Rx<RoomTransaction>(RoomTransaction());

  @override
  Future<void> onInit()async{
    await getCurrentRoomTransaction();
    super.onInit();
  }

  Future<void> getCurrentRoomTransaction()async{
    await RoomTransactionRepository().getRoomTransaction(selectedRoom.currentTransactionId!).then((value) {
      if(value.id != null){
        roomTransaction.value = value;
        roomTransaction.refresh();

      }
    });
  }
}