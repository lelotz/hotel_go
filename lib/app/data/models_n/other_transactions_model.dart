class OtherTransactions {
  String? id;
  String? clientId;
  String? employeeId;
  String? roomTransactionId;
  int? roomNumber;
  int? amountPaid;
  int? outstandingBalance;
  int? grandTotal;
  String? paymentNotes;
  String? transactionNotes;
  String? dateTime;
  String? sessionId;

  OtherTransactions(
      {this.id,
        this.clientId,
        this.employeeId,
        this.roomTransactionId,
        this.roomNumber,
        this.amountPaid,
        this.outstandingBalance,
        this.grandTotal,
        this.paymentNotes,
        this.transactionNotes,
        this.sessionId,
        this.dateTime});

  OtherTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    employeeId = json['employeeId'];
    roomTransactionId = json['roomTransactionId'];
    roomNumber = json['roomNumber'];
    amountPaid = json['amountPaid'];
    outstandingBalance = json['outstandingBalance'];
    grandTotal = json['grandTotal'];
    paymentNotes = json['paymentNotes'];
    transactionNotes = json['transactionNotes'];
    sessionId = json['sessionId'];
    dateTime = json['dateTime'];
  }
  List<OtherTransactions> fromJsonList(List<Map<String,dynamic>> value){
    List<OtherTransactions> result = [];
    for(Map<String,dynamic> element in value){
      result.add(OtherTransactions.fromJson(element));
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['employeeId'] = employeeId;
    data['roomTransactionId'] = roomTransactionId;
    data['roomNumber'] = roomNumber;
    data['amountPaid'] = amountPaid;
    data['outstandingBalance'] = outstandingBalance;
    data['grandTotal'] = grandTotal;
    data['paymentNotes'] = paymentNotes;
    data['transactionNotes'] = transactionNotes;
    data['dateTime'] = dateTime;
    data['sessionId'] = sessionId;
    return data;
  }
}