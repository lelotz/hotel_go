class GuestPackage {
  String? id;
  String? dateStored;
  String? dateReturned;
  String? storedEmployeeId;
  String? returnedEmployeeId;
  String? description;
  int? value;
  String? unit;
  int? quantity;
  String? guestId;
  String? roomTransactionId;

  GuestPackage(
      {this.id,
        this.dateStored,
        this.dateReturned,
        this.storedEmployeeId,
        this.returnedEmployeeId,
        this.description,
        this.value,
        this.unit,
        this.quantity,
        this.guestId,
        this.roomTransactionId});

  GuestPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateStored = json['dateStored'];
    dateReturned = json['dateReturned'];
    storedEmployeeId = json['storedEmployeeId'];
    returnedEmployeeId = json['returnedEmployeeId'];
    description = json['description'];
    value = json['value'];
    unit = json['unit'];
    quantity = json['quantity'];
    guestId = json['guestId'];
    roomTransactionId = json['roomTransactionId'];
  }

  static List<GuestPackage> fromJsonList(List<Map<String, dynamic>> value){
    List<GuestPackage> data = [];

    for(Map<String, dynamic> element in value){
      data.add(GuestPackage.fromJson(element));
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateStored'] = this.dateStored;
    data['dateReturned'] = this.dateReturned;
    data['storedEmployeeId'] = this.storedEmployeeId;
    data['returnedEmployeeId'] = this.returnedEmployeeId;
    data['description'] = this.description;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['quantity'] = this.quantity;
    data['guestId'] = this.guestId;
    data['roomTransactionId'] = this.roomTransactionId;
    return data;
  }
}