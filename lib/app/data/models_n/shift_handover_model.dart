
class ShiftHandOver {
  String? id;
  String? incomingEmployeeId;
  String? outgoingEmployeeId;
  String? dateTime;

  ShiftHandOver(
      {this.id,
        this.incomingEmployeeId,
        this.outgoingEmployeeId,
        this.dateTime});

  ShiftHandOver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    incomingEmployeeId = json['incomingEmployeeId'];
    outgoingEmployeeId = json['outgoingEmployeeId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['incomingEmployeeId'] = incomingEmployeeId;
    data['outgoingEmployeeId'] = outgoingEmployeeId;
    data['dateTime'] = dateTime;
    return data;
  }
}