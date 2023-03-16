class HotelIssues {
  String? id;
  String? employeeId;
  int? roomNumber;
  String? dateTime;
  String? issueDescription;
  String? stepsTaken;
  String? issueStatus;
  String? issueType;

  HotelIssues(
      {this.id,
        this.employeeId,
        this.roomNumber,
        this.dateTime,
        this.issueDescription,
        this.stepsTaken,
        this.issueStatus,
        this.issueType});

  HotelIssues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    roomNumber = json['roomNumber'];
    dateTime = json['dateTime'];
    issueDescription = json['issueDescription'];
    stepsTaken = json['stepsTaken'];
    issueStatus = json['issueStatus'];
    issueType = json['issueType'];
  }
  List<HotelIssues> fromJsonList(List<Map<String,dynamic>> value){
    List<HotelIssues> issues = [];
    for(Map<String,dynamic> element in value){
      issues.add(HotelIssues.fromJson(element));
    }
    return issues;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['roomNumber'] = roomNumber;
    data['dateTime'] = dateTime;
    data['issueDescription'] = issueDescription;
    data['stepsTaken'] = stepsTaken;
    data['issueStatus'] = issueStatus;
    data['issueType'] = issueType;
    return data;
  }
}