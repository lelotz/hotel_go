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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clientId'] = this.clientId;
    data['employeeId'] = this.employeeId;
    data['roomTransactionId'] = this.roomTransactionId;
    data['roomNumber'] = this.roomNumber;
    data['amountPaid'] = this.amountPaid;
    data['outstandingBalance'] = this.outstandingBalance;
    data['grandTotal'] = this.grandTotal;
    data['paymentNotes'] = this.paymentNotes;
    data['transactionNotes'] = this.transactionNotes;
    data['dateTime'] = this.dateTime;
    return data;
  }
}