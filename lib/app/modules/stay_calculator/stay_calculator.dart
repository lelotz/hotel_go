
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/models_n/room_data_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';

import '../../../core/values/app_constants.dart';
import '../../data/models_n/other_transactions_model.dart';

class StayCalculator {
  int roomPrice = 0;
  late int roomNumber;
  String roomTransactionId;
  List<OtherTransactions>? otherTransactions;
  RoomData roomData;

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
    roomTransaction.checkOutDate = checkOutDate;

    int daysStayed = getDaysStayed(roomTransaction,newCheckOutDate: roomTransaction.checkOutDate);
    roomTransaction.nights = daysStayed;
    int newCost = calculateRoomCostByRoomNumberAndDays(roomTransaction.roomNumber!, daysStayed);
    int amountAdded = newCost - roomTransaction.roomCost!;
    roomTransaction.roomCost = newCost;
    roomTransaction.grandTotal = roomTransaction.grandTotal! + amountAdded;

    roomTransaction.roomOutstandingBalance = roomTransaction.roomCost! - roomTransaction.roomAmountPaid!;
    roomTransaction.outstandingBalance = roomTransaction.grandTotal! - roomTransaction.amountPaid!;

    await RoomTransactionRepository().updateRoomTransaction(
        roomTransaction.toJson(), createUserActivity: true,
        updateDetails: 'Badilisha Check-Out Day',
        unit: 'Tarehe',
    );

    return roomTransaction;

  }

  int getDaysStayed(RoomTransaction roomTransaction,{String? newCheckOutDate}){
    return DateTime.parse(newCheckOutDate ?? roomTransaction.checkOutDate!).difference(DateTime.parse(roomTransaction.checkInDate!)).inDays;
  }





}