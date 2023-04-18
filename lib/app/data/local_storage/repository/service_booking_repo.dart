
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

import '../../models_n/service_booking_model.dart';

class ServiceBookingRepository extends SqlDatabase{
  //
  // ServiceBookingRepository._privateConstruct();
  // static final ServiceBookingRepository instance = ServiceBookingRepository._privateConstruct();

  Future<int?> createServiceBooking(Map<String,dynamic> booking)async{
    return await create(ServiceBookingTable.tableName, booking);
  }

  Future<List<Map<String, dynamic>>?> getServiceBookingByStatus(String status)async{
    return await read(tableName: ServiceBookingTable.tableName,
      where: '${ServiceBookingTable.bookingStatus}=?',
      whereArgs: [status]
    );
  }

  Future<List<Map<String, dynamic>>?> getServiceBookingByBookingStartDate(String selectedDate)async{
    return await read(tableName: ServiceBookingTable.tableName,
        where: '${ServiceBookingTable.serviceStartDate} = ?',
        whereArgs: [selectedDate]
    );
  }

  Future<List<ServiceBooking>> getMultipleServiceBookingsById(List<String> serviceBookingIds)async{
    List<ServiceBooking> serviceBookings = [];
    await read(tableName: ServiceBookingTable.tableName,
        where: '${ServiceBookingTable.id} IN(${buildNQuestionMarks(serviceBookingIds.length)})',
        whereArgs: buildWhereArgsFromList(serviceBookingIds)
    ).then((value) {
      serviceBookings = ServiceBooking().fromJsonList(value ?? []);
    });
    return serviceBookings;
  }


  Future<int?> updateServiceBooking(Map<String, dynamic> row)async{
    return await update(
        tableName: ServiceBookingTable.tableName, row:row,
        where: '${ServiceBookingTable.id} = ?', whereArgs: [row[ServiceBookingTable.id]]);
  }

  Future<int?> deleteServiceBooking(Map<String, dynamic> row)async{
    return await delete(
        tableName: ServiceBookingTable.tableName,
        where: '${ServiceBookingTable.id} = ?', whereArgs: [row[ServiceBookingTable.id]]);
  }



}

class ServiceBookingTable{
  static const String tableName = "bookings";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String bookingDatetime = "bookingDatetime";
  static const String bookingExpiryDateTime = "bookingExpiryDateTime";
  static const String name = "name";
  static const String phone= "phone";
  static const String peopleCount = "peopleCount";
  static const String bookingStatus = "bookingStatus";
  static const String roomNumber = "roomNumber";
  static const String bookingType ="bookingType";
  static const String invoiceNo = "invoiceNo";
  static const String advancePayment = "advancePayment";
  static const String isRoom = "isRoom";
  static const String serviceValue = "serviceValue";
  static const String serviceStartDate = "serviceStartDate";
  static const String serviceEndEndDate = "serviceEndEndDate";

  String sql =
  '''
        CREATE TABLE IF NOT EXISTS $tableName(
        $name TEXT NOT NULL,
        $phone TEXT NOT NULL,
        $bookingType TEXT NOT NULL,
        $serviceValue INT NOT NULL,
        $bookingStatus TEXT NOT NULL,
        $bookingDatetime DATETIME NOT NULL,
        $bookingExpiryDateTime DATETIME NOT NULL,
        $serviceStartDate DATETIME NOT NULL,
        $serviceEndEndDate DATETIME NOT NULL,
        $peopleCount INT NOT NULL,
        $advancePayment TEXT,
        $invoiceNo TEXT,
        $isRoom INT NOT NULL,
        $roomNumber INT,
        $id TEXT PRIMARY KEY,
        $employeeId TEXT NOT NULL )
      ''';
}