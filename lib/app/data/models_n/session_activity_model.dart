
class SessionActivity {
  String? id;
  String? sessionId;
  String? transactionId;
  String? transactionType;

  SessionActivity(
      {this.id, this.sessionId, this.transactionId, this.transactionType});

  SessionActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['sessionId'];
    transactionId = json['transactionId'];
    transactionType = json['transactionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sessionId'] = sessionId;
    data['transactionId'] = transactionId;
    data['transactionType'] = transactionType;
    return data;
  }

  List<SessionActivity> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<SessionActivity> objList = [];
    for (Map<String, dynamic> json in jsonList) {
      objList.add(SessionActivity.fromJson(json));
    }
    return objList;
  }
  
  
}