class UserActivity {
  String? activityId;
  String? roomTransactionId;
  String? employeeId;
  String? employeeFullName;
  String? guestId;
  String? activityStatus;
  String? description;
  int? activityValue;
  String? unit;
  String? dateTime;

  UserActivity(
      {this.activityId,
        this.roomTransactionId,
        this.employeeId,
        this.employeeFullName,
        this.guestId,
        this.activityStatus,
        this.description,
        this.activityValue,
        this.unit,
        this.dateTime});

  UserActivity.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    roomTransactionId = json['roomTransactionId'];
    employeeId = json['employeeId'];
    employeeFullName = json['employeeFullName'];
    guestId = json['guestId'];
    activityStatus = json['activityStatus'];
    description = json['description'];
    activityValue = json['activityValue'];
    unit = json['unit'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activityId'] = activityId;
    data['roomTransactionId'] = roomTransactionId;
    data['employeeId'] = employeeId;
    data['employeeFullName'] = employeeFullName;
    data['guestId'] = guestId;
    data['activityStatus']= activityStatus;
    data['description'] = description;
    data['activityValue'] = activityValue;
    data['unit'] = unit;
    data['dateTime'] = dateTime;
    return data;
  }
}