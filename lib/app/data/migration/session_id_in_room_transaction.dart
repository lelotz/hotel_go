

import 'package:hotel_pms/app/data/local_storage/repository/other_transactions_repo.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:logger/logger.dart';

import '../../../core/values/localization/local_keys.dart';
import '../local_storage/repository/collected_payments_repo.dart';
import '../local_storage/repository/room_transaction_repo.dart';
import '../local_storage/repository/session_management_repo.dart';
import '../models_n/collect_payment_model.dart';
import '../models_n/room_transaction.dart';
import '../models_n/session_activity_model.dart';

class SessionIdInjector{

  /// RoomTransaction and OtherTransaction
  static Logger logger = AppLogger.instance.logger;

  Map<String,dynamic> roomTransactionAndSessionIds = {};

  List<String> getSessionActivityIds(List<SessionActivity> transactions) {
    List<String> transactionsIds = [];
    for (SessionActivity transaction in transactions) {
      if (transaction.transactionId != null) {
        transactionsIds.add(transaction.transactionId ?? '');
      }
    }
    return transactionsIds;
  }
  List<String> getRoomTransactionIds(List<RoomTransaction> transactions) {
    List<String> transactionsIds = [];
    for (RoomTransaction transaction in transactions) {
      if (transaction.id != null) {
        transactionsIds.add(transaction.id!);
      }
    }
    return transactionsIds;
  }

  static injectSessionIdInRoomTransactions()async{
    /// GetAllRoomTransactions
    /// Get Ids
    /// Use id in ids to get Room sessionActivities
    /// Get the oldest sessionActivity
    /// Assign oldest SessionActivity sessionId to roomTransaction
    List<RoomTransaction> roomTransactions = await RoomTransactionRepository().getAllRoomTransactions();
    for(RoomTransaction transaction in roomTransactions){
      List<SessionActivity> sessionActivity = await SessionManagementRepository().getSessionActivityByTransactionId(transaction.id!);
      sessionActivity.sort((a,b)=>DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
      if(sessionActivity.isNotEmpty){
        transaction.sessionId = sessionActivity.last.sessionId;
        await RoomTransactionRepository().updateRoomTransaction(transaction.toJson());
      }
    }
  }

  static injectSessionIdInOtherTransactions()async{
    /// GetAll RoomTransactions
    /// Get Ids
    /// Use id in ids to get Room sessionActivitys
    /// Get the oldest sessionActivity
    /// Assign oldest SessionActivity sessionId to roomTransaction

    List<OtherTransactions> otherTransactions =  await OtherTransactionsRepository().getAllOtherTransactions();

    for(OtherTransactions transaction in otherTransactions){
      List<SessionActivity> sessionActivity = await SessionManagementRepository().getSessionActivityByTransactionId(transaction.id!);
      sessionActivity.sort((a,b)=>DateTime.parse(b.dateTime!)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
      // print(sessionActivity);
      if(sessionActivity.isNotEmpty){
        transaction.sessionId = sessionActivity.last.sessionId;
        await OtherTransactionsRepository().updateOtherTransaction(transaction.toJson());
      }

    }

  }

  static int differenceInHours(DateTime a, DateTime b){
    return b.difference(a).inHours;
  }

  static bool isBetween(DateTime a, DateTime b,DateTime given){
    if(given.isAfter(a) && given.isBefore(b)){
      return true;
    }
    return false;
  }

  static Future<void> injectCollectedPayments()async{
    List<CollectPayment> collectedPayments = await CollectedPaymentsRepository().getAllCollectedPayments();
    List<SessionTracker> sessions = await SessionManagementRepository().getAllSessionTrackers();
    /// cp date time is between session.s and session end
    for(CollectPayment payment in collectedPayments){
      for(SessionTracker session in sessions){
        DateTime paymentDate = DateTime.parse(payment.dateTime!);
        DateTime sessionStartDate = DateTime.parse(session.dateCreated!);
        DateTime sessionEndDate = DateTime.parse(session.dateEnded ?? session.dateCreated!);

        if(differenceInHours(sessionStartDate, sessionEndDate) < 24 &&
            isBetween(sessionStartDate,sessionEndDate,paymentDate)
        ){
            payment.sessionId = session.id;
            await CollectedPaymentsRepository().updateCollectedPayment(payment.toJson());
        }
      }
    }
  }

  fun({required String sessionId})async{
    List<SessionActivity> roomSessionActivity = await SessionManagementRepository().getSessionActivityByTransactionTypeAndExcludeSessionId(LocalKeys.kRoom, sessionId);
    List<RoomTransaction> roomTransactions = await RoomTransactionRepository().getMultipleRoomTransactions(getSessionActivityIds(roomSessionActivity));
    List<CollectPayment> collectedPayments = await CollectedPaymentsRepository().getMultipleCollectedPaymentsByIds(getRoomTransactionIds(roomTransactions), LocalKeys.kRoom);


  }

}