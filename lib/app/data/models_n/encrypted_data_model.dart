
class EncryptedData {
  String? userId;
  String? data;

  EncryptedData({this.userId, this.data});

  EncryptedData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['data'] = this.data;
    return data;
  }
}