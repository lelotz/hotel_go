

class SessionTracker {
  String? id;
  String? employeeId;
  String? dateCreated;
  String? dateEnded;

  SessionTracker({this.id, this.employeeId, this.dateCreated, this.dateEnded});

  SessionTracker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    dateCreated = json['dateCreated'];
    dateEnded = json['dateEnded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['dateCreated'] = dateCreated;
    data['dateEnded'] = dateEnded;
    return data;
  }

  List<SessionTracker> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<SessionTracker> objList = [];
    for (Map<String, dynamic> json in jsonList) {
      objList.add(SessionTracker.fromJson(json));
    }
    return objList;
  }
}