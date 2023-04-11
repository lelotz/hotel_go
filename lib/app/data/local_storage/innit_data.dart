
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/encrypted_data_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_data_repository.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_status_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/core/values/app_constants.dart';

import '../../../core/values/localization/local_keys.dart';
import '../models_n/encrypted_data_model.dart';
import '../models_n/room_data_model.dart';
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';

/// This function Creates initial data necessary to run the system
///
/// This data includes the
/// [AdminUser]
/// [RoomData] and
/// [RoomStatusModel]
Future<int> loadInitData(List<RoomData> roomData, List<RoomStatusModel> roomStatus,List<AdminUser> adminUsers)async{
  //int testUsers = adminUsers.length;



  for(RoomData element in roomData){
    await RoomDataRepository().createRoom(element.toJson());
  }

  for(RoomStatusModel element in roomStatus){
    await RoomStatusRepository().createRoomStatus(element.toJson());
  }

  for(AdminUser element in adminUsers){
    await AdminUserRepository().createAdminUser(element.toJson());
    await EncryptedDataRepository().createEncryptedData(EncryptedData(userId: element.appId,data: '').toJson());
  }

  //  Future.forEach(adminUsers, (element) async{
  //   await AdminUserRepository().createAdminUser(element.toJson());
  //   await EncryptedDataRepository().createEncryptedData(EncryptedData(userId: element.appId,data: '').toJson());
  // });

  //  Future.forEach(roomData, (element) async{
  //   await RoomDataRepository().createRoom(element.toJson());
  // });

  //  Future.forEach(roomStatus, (element) async{
  //   await RoomStatusRepository().createRoomStatus(element.toJson());
  // });

  return 0;

}

List<AdminUser> initAdminUsers = [
  AdminUser(
    appId: "00001WH",
    fullName: "Dereck Olomi",
    position: AppConstants.userRoles[1],
    phone: "",
    roomsSold: 0,
    status: 'ENABLED',
  ),
  AdminUser(
    appId: "00002WH",
    fullName: "Housekeeper Example",
    position: AppConstants.userRoles[600],
    phone: "0755148965",
    roomsSold: 0,
    status: 'ENABLED',
  ),
  // AdminUser(
  //   appId: "00002WH",
  //   fullName: "Asha Lloyd",
  //   position: AppConstants.userRoles[300],
  //   phone: "",
  //   roomsSold: 0,
  //     status: 'ENABLED',
  // ),
  // AdminUser(
  //   appId: "00003WH",
  //   fullName: "Salama Joachim",
  //   position: AppConstants.userRoles[300],
  //   phone: "",
  //   roomsSold: 0,
  //   status: 'ENABLED',
  //
  //
  // ),
  // AdminUser(
  //   appId: "00004WH",
  //   fullName: "Esther Ritva",
  //   position: AppConstants.userRoles[300],
  //   phone: "",
  //   roomsSold: 0,
  //   status: 'ENABLED',
  //
  // ),
];

List<RoomData> initRoomData = [
  RoomData(
    roomNumber: 101,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 102,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 103,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 104,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 105,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 106,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 107,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 108,
    isVIP: 0,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 201,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 202,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 203,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 204,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 205,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 206,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 207,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 208,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 209,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 210,
    isVIP: 1,
    currentTransactionId: "",
  ),
  RoomData(
    roomNumber: 211,
    isVIP: 1,
    currentTransactionId: "",
  ),
];

List<RoomStatusModel> initRoomStatus = [
  RoomStatusModel(
    roomId: 101,
    code: LocalKeys.kStatusCode100.toString(),
    description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 102,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 103,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 104,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 105,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 106,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 107,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 108,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),

  RoomStatusModel(
      roomId: 201,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 202,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 203,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 204,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 205,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 206,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 207,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 208,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 209,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 210,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),
  RoomStatusModel(
      roomId: 211,
      code: LocalKeys.kStatusCode100.toString(),
      description: AppConstants.roomStatus[LocalKeys.kStatusCode100.toString()]
  ),

];