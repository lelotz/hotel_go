
class PettyCashStatus {
  String? id;
  String? employeeId;
  String? dateTime;
  String? availableCash;
  String? usedCash;

  PettyCashStatus(
      {this.id,
        this.employeeId,
        this.dateTime,
        this.availableCash,
        this.usedCash});

  PettyCashStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    dateTime = json['dateTime'];
    availableCash = json['availableCash'];
    usedCash = json['usedCash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['dateTime'] = dateTime;
    data['availableCash'] = availableCash;
    data['usedCash'] = usedCash;
    return data;
  }
}