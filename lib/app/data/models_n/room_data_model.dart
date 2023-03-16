
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';

class RoomData {
  int? roomNumber;
  int? isVIP;
  String? currentTransactionId;
  RoomStatusModel? roomStatus;

  RoomData({this.roomNumber, this.isVIP, this.currentTransactionId,this.roomStatus});

  RoomData.fromJson(Map<String, dynamic> json) {
    roomNumber = json['roomNumber'];
    isVIP = json['isVIP'];
    currentTransactionId = json['currentTransactionId'];
    //roomStatus = json['roomStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['roomNumber'] = roomNumber;
    data['isVIP'] = isVIP;
    data['currentTransactionId'] = currentTransactionId;
    //data['roomStatus'] = roomStatus;
    return data;
  }
}