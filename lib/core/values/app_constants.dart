


import 'dart:ui';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/client_user_model.dart';


import '../resourses/color_manager.dart';
import 'localization/local_keys.dart';

class AppGlobals {
  ClientUser? currentUser;
}

class TransactionTypes{
  TransactionTypes._();

  static const String conferenceBooking = LocalKeys.kConferenceBooking;
  static const String roomCheckIn = LocalKeys.kCheckIn;
  static const String roomCheckOut = LocalKeys.kCheckout;
  static const String laundryPayment = LocalKeys.kLaundry;
  static const String room = LocalKeys.kRoom;
  static const String roomServiceTransaction = LocalKeys.kRoomService;
  static const String hotelIssue = 'HotelIssue';


}

class HotelIssueType{
  HotelIssueType._();
  static const String brokenItem = "Broken Item";
  static const String guests = "Guests";
  static const String fights = "Fight";
  static const String powerIssue = "Electricity";
  static const String waterIssue = "Water";
  static const String otherIssue = "Other";

  //static List<String> toList(){return [];}
  static List<String> getHotelIssueTypes(){
    return const [brokenItem,guests,fights,powerIssue,waterIssue,otherIssue];

  }

  static List<String> getHotelIssueStatus(){
    return const ['Solved','Pending'];
  }
}

class AppConstants {
  AppConstants._();

  /// 1 [ADMIN]
  /// 300 [RECEPTIONIST]

  static const String roomServiceLabel = "ROOM-SERVICE";
  static const String laundryLabel = "LAUNDRY";

  static const int laundryPrice = 1000;


  static const Map<int,String> userRoles = {
    1: 'Admin',
    500: 'Hotel Owner',
    200:'Client',
    400:'Finance',
    300:'Receptionist',
  };

  static  const Map<String,dynamic> serviceTypes = {
    LocalKeys.kRoom:LocalKeys.kRoom,
    LocalKeys.kRoomService:LocalKeys.kRoomService,
    LocalKeys.kLaundry:LocalKeys.kLaundry,
    LocalKeys.kAll :LocalKeys.kAll
  };
  static  Map<String,dynamic> roomStatus = {
    LocalKeys.kStatusCode100.toString() : LocalKeys.kAvailable.tr,
    LocalKeys.kStatusCode200.toString(): LocalKeys.kOccupied.tr,
    LocalKeys.kStatusCode50.toString() : LocalKeys.kOut.tr,
    LocalKeys.kStatusCode150.toString(): LocalKeys.kHouseKeeping.tr,
    LocalKeys.kStatusCode0.toString()  : LocalKeys.kOutOfOrder.tr
  };
  static  Map<String,Color> roomStatusColor = {
    LocalKeys.kStatusCode100.toString() : ColorsManager.success,
    LocalKeys.kStatusCode200.toString(): ColorsManager.error,
    LocalKeys.kStatusCode50.toString() : ColorsManager.lightGrey,
    LocalKeys.kStatusCode150.toString(): ColorsManager.primary,
    LocalKeys.kStatusCode0.toString()  : ColorsManager.black
  };



  static const Map<String,dynamic> roomType = {
    LocalKeys.kVip : 35000,
    LocalKeys.kStd : 30000,
  };


  static List<String> formNames = [
    LocalKeys.kStorePackage,
    LocalKeys.kLaundry,
    LocalKeys.kRoomService,
    LocalKeys.kCollectPayment,

  ];

  static Map<String,dynamic> formNamesMap = {
    LocalKeys.kRoomService.tr:LocalKeys.kRoomService,
    LocalKeys.kStorePackage.tr:LocalKeys.kStorePackage,
    LocalKeys.kCollectPayment.tr:LocalKeys.kCollectPayment,
    LocalKeys.kLaundry.tr :LocalKeys.kLaundry
  };
  static const List<String> hotelImages = [
  ];
}

class RoomStatusTypes {
  static const String available =  LocalKeys.kAvailable;
  static const String occupied =  LocalKeys.kOccupied;
  static const String out =  LocalKeys.kOut;
  static const String housekeeping =  LocalKeys.kHouseKeeping;
  static const String outOfOrder =  LocalKeys.kOutOfOrder;
  static const String booked =  'booked';
}

class BookingStatusTypes {
  static const String active =  'active';
  static const String expired =  'expired';
  static const String complete =  'complete';
}
