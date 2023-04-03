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
    dateTime = json['dateTime'];
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
    return data;
  }
}