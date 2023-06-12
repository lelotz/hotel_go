import 'package:hotel_pms/app/data/models_n/internl_transaction_model.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/service_booking_model.dart';

import '../../../app/data/models_n/room_transaction.dart';
import '../../utils/string_handlers.dart';

class SummaryCalculator{

  static int calculateRoomDebts(List<RoomTransaction> roomTransactions){
    int result = 0;
    for(RoomTransaction transaction in roomTransactions){
      result += transaction.roomOutstandingBalance ?? 0;
    }
    return result;
  }

  static int calculateRoomAmountPaid(List<RoomTransaction> roomTransactions){
    int result = 0;
    for(RoomTransaction transaction in roomTransactions){
      result += transaction.roomAmountPaid ?? 0;
    }
    return result;
  }

  static int calculateRoomCost(List<RoomTransaction> roomTransactions){
    int result = 0;
    for(RoomTransaction transaction in roomTransactions){
      result += transaction.roomCost ?? 0;
    }
    return result;
  }

  static int calculateRoomServiceAmountPaid(List<OtherTransactions> roomServiceTransactions){
    int result = 0;
    for(OtherTransactions transaction in roomServiceTransactions){
      result += transaction.amountPaid ?? 0;
    }
    return result;
  }

  static int calculateRoomServiceDebts(List<OtherTransactions> roomServiceTransactions){
    int result = 0;
    for(OtherTransactions transaction in roomServiceTransactions){
      result += transaction.outstandingBalance ?? 0;
    }
    return result;
  }

  static int calculateRoomServiceCost(List<OtherTransactions> roomServiceTransactions){
    int result = 0;
    for(OtherTransactions transaction in roomServiceTransactions){
      result += transaction.grandTotal ?? 0;
    }
    return result;
  }

  static int calculatePettyCashGiven(List<InternalTransaction> pettyCashTransactions){
    int result = 0;

    for(InternalTransaction transaction in pettyCashTransactions){
      result += transaction.transactionValue ?? 0;
    }
    return result;
  }

  static int calculateConferenceAdvancePayments(List<ServiceBooking> conferenceAdvancePayments){
    int result = 0;

    for(ServiceBooking transaction in conferenceAdvancePayments){
      result += stringToInt(transaction.advancePayment);
    }
    return result;
  }

  static int calculateConferenceCosts(List<ServiceBooking> conferenceAdvancePayments){
    int result = 0;

    for(ServiceBooking transaction in conferenceAdvancePayments){
      result += transaction.serviceValue ?? 0;
    }
    return result;
  }


}