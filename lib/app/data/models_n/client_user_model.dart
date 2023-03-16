
class ClientUser {
  String? clientId;
  String? fullName;
  String? lastName;
  String? firstName;
  String? idType;
  String? idNumber;
  String? countryOfBirth;

  ClientUser(
      {this.clientId,
        this.fullName,
        this.lastName,
        this.firstName,
        this.idType,
        this.idNumber,
        this.countryOfBirth});

  ClientUser.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    fullName = json['fullName'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    idType = json['idType'];
    idNumber = json['idNumber'];
    countryOfBirth = json['countryOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['fullName'] = fullName;
    data['lastName'] = lastName;
    data['firstName'] = firstName;
    data['idType'] = idType;
    data['idNumber'] = idNumber;
    data['countryOfBirth'] = countryOfBirth;
    return data;
  }
}