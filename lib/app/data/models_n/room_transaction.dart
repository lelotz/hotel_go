
class RoomTransaction {
  String? id;
  String? clientId;
  String? employeeId;
  int? roomNumber;
  int? roomAmountPaid;
  int? roomOutstandingBalance;
  int? amountPaid;
  int? outstandingBalance;
  String? paymentNotes;
  String? transactionNotes;
  String? date;
  String? time;
  String? checkInDate;
  String? checkOutDate;
  int? nights;
  int? roomCost;
  String? arrivingFrom;
  String? goingTo;
  int? grandTotal;
  int? otherCosts;
  String? sessionId;

  RoomTransaction(
      {this.id,
        this.clientId,
        this.sessionId,
        this.employeeId,
        this.roomNumber,
        this.paymentNotes,
        this.transactionNotes,
        this.date,
        this.time,
        this.checkInDate,
        this.checkOutDate,
        this.nights,
        this.arrivingFrom,
        this.amountPaid=0,
        this.roomCost=0,
        this.roomAmountPaid=0,
        this.roomOutstandingBalance=0,
        this.outstandingBalance=0,
        this.goingTo,
        this.grandTotal,
        this.otherCosts}
      );

  RoomTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    employeeId = json['employeeId'];
    roomNumber = json['roomNumber'];
    amountPaid = json['amountPaid'];
    outstandingBalance = json['outstandingBalance'];
    paymentNotes = json['paymentNotes'];
    transactionNotes = json['transactionNotes'];
    sessionId = json['sessionId'];
    date = json['date'];
    time = json['time'];
    checkInDate = json['checkInDate'];
    checkOutDate = json['checkOutDate'];
    nights = json['nights'];
    roomCost = json['roomCost'];
    arrivingFrom = json['arrivingFrom'];
    goingTo = json['goingTo'];
    grandTotal = json['grandTotal'];
    otherCosts = json['otherCosts'];
    roomOutstandingBalance = json['roomOutstandingBalance'];
    roomAmountPaid = json['roomAmountPaid'];
  }

  List<RoomTransaction> fromJsonList(List<Map<String,dynamic>> value){
    List<RoomTransaction> roomTransactions = [];
    for(Map<String,dynamic> roomTransaction in value){
      roomTransactions.add(RoomTransaction.fromJson(roomTransaction));
    }
    return roomTransactions;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['employeeId'] = employeeId;
    data['roomNumber'] = roomNumber;
    data['amountPaid'] = amountPaid;
    data['outstandingBalance'] = outstandingBalance;
    data['paymentNotes'] = paymentNotes;
    data['transactionNotes'] = transactionNotes;
    data['date'] = date;
    data['time'] = time;
    data['checkInDate'] = checkInDate;
    data['checkOutDate'] = checkOutDate;
    data['nights'] = nights;
    data['roomCost'] = roomCost;
    data['arrivingFrom'] = arrivingFrom;
    data['goingTo'] = goingTo;
    data['grandTotal'] = grandTotal;
    data['otherCosts'] = otherCosts;
    data['roomAmountPaid'] = roomAmountPaid;
    data['roomOutstandingBalance']=roomOutstandingBalance;
    data['sessionId'] = sessionId;
    return data;
  }
}