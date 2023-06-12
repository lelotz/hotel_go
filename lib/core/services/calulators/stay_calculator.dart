
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/models_n/room_data_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import '../../../app/data/local_storage/repository/other_transactions_repo.dart';
import '../../logs/logger_instance.dart';
import '../../values/app_constants.dart';
import '../../../app/data/models_n/other_transactions_model.dart';

class StayCalculator {
  int roomPrice = 0;
  late int roomNumber;
  String roomTransactionId;
  List<OtherTransactions>? otherTransactions;
  RoomData roomData;
  Logger logger = AppLogger.instance.logger;
  int? otherTransactionsGrandTotal;
  int? otherTransactionsAmountPaid;
  int? otherTransactionsOutstandingBalance;

  StayCalculator({required this.roomData,this.roomTransactionId=''}){
    roomNumber = roomData.roomNumber ?? 0;
    roomTransactionId = roomData.currentTransactionId!;
  }

  int calculateRoomPriceByRoomNumber({int? givenRoomNumber}){
    if(givenRoomNumber!=null){
      return givenRoomNumber < 200 ? 30000 : 35000;
    }else{
      return roomNumber < 200 ? 30000 : 35000;
    }
  }

  int calculateRoomCostByRoomNumberAndDays(int roomNumber,int days){
    return calculateRoomPriceByRoomNumber(givenRoomNumber: roomNumber) * days;
  }


  int calculateRoomPriceByRoomType(RoomData roomData){
    return roomData.isVIP == 1 ? AppConstants.roomType['VIP']! : AppConstants.roomType['STD']!;
  }

  int calculateStayCostByRoomTypeAndDays(RoomData roomData, int days){
    return calculateRoomPriceByRoomType(roomData) * days;
  }

  Future<RoomTransaction> updateStayCostByCheckOutDate(String checkOutDate,RoomTransaction roomTransaction)async{
    roomTransaction.checkOutDate = resetTimeInDateTime(DateTime.parse(checkOutDate),toGivenHM: true,hour: 10,minute: 0);

    int daysStayed = getDaysStayed(roomTransaction,newCheckOutDate: roomTransaction.checkOutDate);
    roomTransaction.nights = daysStayed;
    int newCost = calculateRoomCostByRoomNumberAndDays(roomTransaction.roomNumber!, daysStayed);
    int amountAdded = newCost - roomTransaction.roomCost!;
    roomTransaction.roomCost = newCost;
    roomTransaction.grandTotal = roomTransaction.grandTotal! + amountAdded;
    roomTransaction.roomOutstandingBalance = roomTransaction.roomCost! - roomTransaction.roomAmountPaid!;
    roomTransaction.outstandingBalance = roomTransaction.grandTotal! - roomTransaction.amountPaid!;

    await RoomTransactionRepository().updateRoomTransaction
      (
        roomTransaction.toJson(), createUserActivity: true,
        updateDetails: 'Badilisha Check-Out Day',
        unit: 'Tarehe',
      );

    return roomTransaction;
  }

  int getDaysStayed(RoomTransaction roomTransaction,{String? newCheckOutDate}){
    int differenceInHours = DateTime.parse(newCheckOutDate ?? roomTransaction.checkOutDate!).difference(DateTime.parse(roomTransaction.checkInDate!)).inHours;
    logger.w('Getting days for more dates MORE than one day apart. Days : ${(differenceInHours/24).ceil()} Hours : $differenceInHours');
    return (differenceInHours/24).ceil();
  }

  /*
  This function takes a payment for room service in the form of a
  List of OtherTransactions objects and divides the payment among the room services in the List
  This is done because client may pay an incomplete bill for services rendered
  So for example. John had room service for
  Laundry A (LA): 5,000
  Laundry B (LB): 15,000
  John's payment for roomService was 10,000

  This function will take the payment and apply it to the Laundry A. Using the following logic
     10000 - 5000 = 5000
  if payment - LA >= 0
    then LA = payment - LA
    payment = payment - LB

          5000 - 15000 = - 15000
  else if payment - LB
    then LB = LB - payment

  calculate remaining debt


  5000 + 15000

  If there is a rem
  taking the
  */

  Future<void> updateRoomTransactionWithOtherCosts(int newPayment,OtherTransactions otherTransaction)async{
    RoomTransaction roomTransaction = await RoomTransactionRepository().getRoomTransaction(otherTransaction.roomTransactionId!);
    roomTransaction.outstandingBalance = roomTransaction.outstandingBalance! - newPayment;
    roomTransaction.amountPaid = roomTransaction.amountPaid! + newPayment;
    await RoomTransactionRepository().updateRoomTransaction(roomTransaction.toJson());
  }

  Future<OtherTransactions> calculateOtherTransactionsFees(OtherTransactions transaction,int newPayment)async{
    transaction.amountPaid = transaction.amountPaid! + newPayment;
    transaction.outstandingBalance = transaction.grandTotal! - transaction.amountPaid!;
    await OtherTransactionsRepository().updateOtherTransaction(transaction.toJson());
    await updateRoomTransactionWithOtherCosts(newPayment, transaction);
    return transaction;
  }
  Future<void> insertPaymentsInOtherTransactions({required int payment,required List<OtherTransactions> transactions})async{

    for(OtherTransactions transaction in transactions){
      if(transaction.outstandingBalance! > 0 && transaction.amountPaid != null && payment > 0){
        if(payment - transaction.outstandingBalance! >= 0){
          int collectedPayment = transaction.outstandingBalance!;
          transaction = await calculateOtherTransactionsFees(transaction,transaction.outstandingBalance!);
          payment = payment - collectedPayment;
        }else{
          int collectedPayment = payment;
          transaction = await calculateOtherTransactionsFees(transaction,payment);
          payment = payment - collectedPayment;
        }
      }

    }
  }

  Future<RoomTransaction> insertRoomPaymentInRoomTransaction(int payment,RoomTransaction transaction)async{
    transaction.amountPaid = transaction.amountPaid! + payment;
    transaction.roomAmountPaid = transaction.roomAmountPaid! + payment;
    transaction.roomOutstandingBalance = transaction.roomOutstandingBalance! - payment;
    transaction.outstandingBalance = transaction.outstandingBalance! - payment;

    await RoomTransactionRepository().updateRoomTransaction(transaction.toJson());
    return transaction;
  }
}