//
// import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
// import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
// import 'package:hotel_pms/app/data/models_n/room_status_model.dart';
// import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
// import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
//
// import '../models_n/admin_user_model.dart';
// import '../models_n/client_user_model.dart';
// import '../models_n/room_data_model.dart';
// Future<void> createTableDataTest()async{
//   Map<String,dynamic> testResults = {};
//
//
//   int? adminUserRowNum = await MyDatabaseInterface.instance.createAdminUser(
//       AdminUser(
//           appId: "5050",
//           fullName: "Dereck Olomi",
//           position: "Admin",
//           phone: "074587455",
//           roomsSold: 0
//       ).toJson()
//   );
//   testResults.addAll({"AdminUser": adminUserRowNum! >= 1  ? "PASS": "FAILS"});
//
//   int? clientUserRowNum = await MyDatabaseInterface.instance.createClientUser(
//       ClientUser(
//           clientId: "1010",
//           fullName: "Dereck Olomi",
//           idType: "Passport",
//           idNumber: "HKBSDJKSF7239FB",
//           countryOfBirth: "Tanzania"
//       ).toJson()
//   );
//   testResults.addAll({"ClientUser": clientUserRowNum! >= 1  ? "PASS": "FAILS"});
//
//   int? roomRowNum = await MyDatabaseInterface.instance.createRoom(
//       RoomData(
//         roomNumber: 102,
//         isVIP: 0,
//         currentTransactionId: "1010"
//       ).toJson()
//   );
//   testResults.addAll({"RoomData": roomRowNum! >= 1  ? "PASS": "FAILS"});
//
//   int? roomStatusRowNum = await MyDatabaseInterface.instance.createRoomStatus(
//       RoomStatusModel(
//         roomId: 102,
//         code: "100",
//         description: "Occupied"
//       ).toJson()
//   );
//   testResults.addAll({"RoomStatus": roomStatusRowNum! >= 1  ? "PASS": "FAILS"});
//
//   int? transactionRowNum = await MyDatabaseInterface.instance.createRoomTransaction(
//       RoomTransaction(
//         id: "10",
//         clientId: "1010",
//         employeeId: "5050",
//         roomNumber: 102,
//         date: DateTime.now().toIso8601String(),
//         checkInDate: DateTime.now().toIso8601String(),
//         checkOutDate: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
//         nights: 2,
//         roomCost: 60000,
//         otherCosts: 30000,
//         grandTotal: 90000,
//         amountPaid: 30000,
//         outstandingBalance: 60000,
//         paymentNotes: "Requested Payment at Check-Out",
//         transactionNotes: "",
//         arrivingFrom: "Kenya",
//         goingTo: "Dar"
//       ).toJson()
//   );
//   testResults.addAll({"RoomTransaction": transactionRowNum! >= 1  ? "PASS": "FAILS"});
//
//   int? otherTransactionsRowNum = await MyDatabaseInterface.instance.createOtherTransaction(
//       OtherTransactions(
//           roomTransactionId: "10",
//           dateTime: DateTime.now().toString(),
//           id: "123",
//           clientId: "1010",
//           employeeId: "5050",
//           roomNumber: 102,
//           transactionNotes: "ROOM-SERVICE",
//           paymentNotes: "REQUESTED-PAYMENT-AT-CHECK-OUT",
//           grandTotal: 30000,
//           amountPaid: 0,
//           outstandingBalance: 30000,
//       ).toJson()
//   );
//   testResults.addAll({"OtherTransactions": otherTransactionsRowNum! >= 1 ? "PASS": "FAILS"});
//
//   int? userActivityRowNum = await MyDatabaseInterface.instance.createUserActivity(
//       UserActivity(
//           activityId: "58",
//           roomTransactionId: "10",
//           employeeId: "5050",
//           guestId: "1010",
//           activityValue: 60000,
//           unit: "ROOM",
//           dateTime: DateTime.now().toString(),
//           activityStatus: "",
//           description: "Check-In"
//       ).toJson()
//   );
//   testResults.addAll({"UserActivity": userActivityRowNum! >= 1 ? "PASS": "FAILS"});
//
//   print("[CREATE & INSERT TEST]");
//   testResults.forEach((key, value) {
//     print("$key: $value");
//   });
//
// }
// Future<void> readTableDataTest()async{
//   Map<String,dynamic> testResults = {};
//
//   testResults.addAll({"AdminUser": await MyDatabaseInterface.instance.getAdminUser(AdminUser(
//       appId: "5050",
//       fullName: "Dereck Olomi",
//       position: "Admin",
//       phone: "074587455",
//       roomsSold: 0
//       ).toJson())});
//
//   testResults.addAll({"ClientUser": await MyDatabaseInterface.instance.getClientUser("1010")});
//
//   testResults.addAll({"Rooms": await MyDatabaseInterface.instance.getAllRooms()});
//
//   testResults.addAll({"Room": await MyDatabaseInterface.instance.getRoom(102)});
//
//   testResults.addAll({"RoomStatus": await MyDatabaseInterface.instance.getRoomsStatus(102)});
//
//   testResults.addAll({"RoomTransaction": await MyDatabaseInterface.instance.getRoomTransaction("10")});
//
//   testResults.addAll({"UserActivity": await MyDatabaseInterface.instance.getUserActivity("58", "10")});
//
//   testResults.addAll({"OtherTransaction":await MyDatabaseInterface.instance.getOtherTransaction("10")});
//
//
//   print("[READ TEST]");
//   testResults.forEach((key, value) {
//     print("$key : $value");
//   });
//
// }
//
