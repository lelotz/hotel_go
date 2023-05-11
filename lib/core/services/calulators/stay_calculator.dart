
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/models_n/room_data_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:logger/logger.dart';
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
}