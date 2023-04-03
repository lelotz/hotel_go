
import 'package:hotel_pms/app/data/models_n/room_status_model.dart';

class RoomData {
  int? roomNumber;
  int? isVIP;
  String? currentTransactionId;
  String? nextAvailableDate;
  RoomStatusModel? roomStatus;

  RoomData({this.roomNumber, this.isVIP, this.currentTransactionId,this.roomStatus,this.nextAvailableDate});

  RoomData.fromJson(Map<String, dynamic> json) {
    roomNumber = json['roomNumber'];
    isVIP = json['isVIP'];
    currentTransactionId = json['currentTransactionId'];
    nextAvailableDate = json['nextAvailableDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomNumber'] = roomNumber;
    data['isVIP'] = isVIP;
    data['currentTransactionId'] = currentTransactionId;
    data['nextAvailableDate'] = nextAvailableDate;
    return data;
  }
}