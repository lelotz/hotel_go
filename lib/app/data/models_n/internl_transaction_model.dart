class InternalTransaction {
  String? id;
  String? employeeId;
  String? beneficiaryName;
  String? beneficiaryId;
  String? description;
  String? dateTime;
  String? transactionType;
  String? transactionValue;


  InternalTransaction(
      {this.id,
        this.employeeId,
        this.beneficiaryName,
        this.beneficiaryId,
        this.description,
        this.transactionType,
        this.transactionValue,
        this.dateTime});

  InternalTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    beneficiaryName = json['beneficiaryName'];
    transactionValue = json['transactionValue'];
    beneficiaryId = json['beneficiaryId'];
    description = json['description'];
    transactionType = json['transactionType'];
    dateTime = json['dateTime'];
  }
  List<InternalTransaction> fromJsonList(List<Map<String, dynamic>> transactions){
    List<InternalTransaction> convertedTransactions = [];
    for(Map<String,dynamic> json in transactions){
      convertedTransactions.add(InternalTransaction.fromJson(json));
    }
    return convertedTransactions;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transactionType'] = transactionType;
    data['employeeId'] = employeeId;
    data['beneficiaryName'] = beneficiaryName;
    data['beneficiaryId'] = beneficiaryId;
    data['description'] = description;
    data['dateTime'] = dateTime;
    data['transactionValue']=transactionValue;
    return data;
  }
}