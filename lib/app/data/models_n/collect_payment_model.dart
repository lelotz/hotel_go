import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/values/localization/local_keys.dart';
import '../local_storage/repository/collected_payments_repo.dart';

class CollectPayment {
  String? id;
  String? roomTransactionId;
  String? employeeId;
  String? employeeName;
  String? clientName;
  String? clientId;
  int? roomNumber;
  int? amountCollected;
  String? dateTime;
  String? date;
  String? time;
  String? service;
  String? payMethod;
  String? receiptNumber;
  String? sessionId;

  CollectPayment(
      {this.id,
        this.roomTransactionId,
        this.employeeId,
        this.employeeName,
        this.clientName,
        this.clientId,
        this.roomNumber,
        this.amountCollected,
        this.date,
        this.dateTime,
        this.time,
        this.service,
        this.payMethod,
        this.sessionId,
        this.receiptNumber});

  CollectPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomTransactionId = json['roomTransactionId'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    clientName = json['clientName'];
    clientId = json['clientId'];
    roomNumber = json['roomNumber'];
    amountCollected = json['amountCollected'];
    sessionId = json['sessionId'];
    date = json['date'];
    dateTime = json['dateTime'];
    time = json['time'];
    service = json['service'];
    payMethod = json['payMethod'];
    receiptNumber = json['receiptNumber'];
  }

  List<CollectPayment> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<CollectPayment> objList = [];
    for (Map<String, dynamic> json in jsonList) {
      objList.add(CollectPayment.fromJson(json));
    }
    return objList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roomTransactionId'] = roomTransactionId;
    data['employeeId'] = employeeId;
    data['employeeName'] = employeeName;
    data['clientName'] = clientName;
    data['clientId'] = clientId;
    data['roomNumber'] = roomNumber;
    data['amountCollected'] = amountCollected;
    data['dateTime'] = dateTime;
    data['date'] = date;
    data['time'] = time;
    data['service'] = service;
    data['payMethod'] = payMethod;
    data['receiptNumber'] = receiptNumber;
    data['sessionId']=sessionId;
    return data;
  }

  Future<int?> toDb()async{
    await UserActivityRepository().createUserActivity(
        UserActivity(
          activityId: const Uuid().v1(),
          activityValue: amountCollected,
          employeeId: employeeId,
          employeeFullName: employeeName,
          activityStatus: service,
          guestId: clientId,
          unit: 'Payment',
          dateTime: dateTime,
          description: LocalKeys.kCollectPayment,
          roomTransactionId: roomTransactionId,
    ).toJson());
   return await CollectedPaymentsRepository().createCollectedPayment(toJson());
  }

}