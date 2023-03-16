
class RoomStatusModel {
  int? roomId;
  String? code;
  String? description;

  RoomStatusModel({this.roomId, this.code, this.description});

  RoomStatusModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    code = json['code'];
    description = json['description'];
  }

  List<RoomStatusModel> fromJsonList(List<Map<String, dynamic>> value){
    List<RoomStatusModel> result = [];
    for(Map<String,dynamic> element in value){
      result.add(RoomStatusModel.fromJson(element));
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}