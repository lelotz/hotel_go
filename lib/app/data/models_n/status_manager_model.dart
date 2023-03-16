class StatusManager {
  String? id;
  String? status;
  String? type;

  StatusManager({this.id, this.status, this.type});

  StatusManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}