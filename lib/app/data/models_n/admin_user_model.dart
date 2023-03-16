
class AdminUser {
  String? appId;
  String? fullName;
  String? firstName;
  String? lastName;
  String? position;
  String? phone;
  String? status;
  int? roomsSold;

  AdminUser(
      {
        this.appId,
        this.fullName,
        this.firstName,
        this.lastName,
        this.position,
        this.phone,
        this.status,
        this.roomsSold}){
   if(fullName != null){
     firstName = fullName!.split(' ')[0];
     lastName = fullName!.split(' ')[1] ?? ' ';
   }
  }

  // AdminUser.incrementRoomsSold(AdminUser adminUser){
  //   int roomsSold = adminUser.roomsSold!;
  //   roomsSold += 1;
  //   return AdminUser(
  //     appId: adminUser.appId,
  //     fullName: adminUser.fullName,
  //     position: adminUser.position,
  //     phone: adminUser.phone,
  //     roomsSold: roomsSold
  //   );
  // }
  AdminUser.incrementRoomsSold(Map<String, dynamic> json) {
    int totalRoomsSold = json['roomsSold'];
    totalRoomsSold += 1;
    status = json['status'];
    appId = json['appId'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    position = json['position'];
    phone = json['phone'];
    roomsSold = totalRoomsSold;
  }


  AdminUser.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    position = json['position'];
    phone = json['phone'];
    roomsSold = json['roomsSold'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['fullName'] = fullName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['position'] = position;
    data['phone'] = phone;
    data['roomsSold'] = roomsSold;
    data['status'] = status;
    return data;
  }
}
