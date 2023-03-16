
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

class ConferenceBookingDetailsRepository extends SqlDatabase{
  ConferenceBookingDetailsRepository();

  Future<int?> createConferenceBookingDetails(Map<String,dynamic> details)async{
    return await create(ConferenceBookingDetailsTable.tableName, details);
  }

  Future<List<Map<String, dynamic>>?> getConferenceBookingDetailsByServiceId(String serviceId)async{
    return await read(
      tableName: ConferenceBookingDetailsTable.tableName,
      where: '${ConferenceBookingDetailsTable.bookingId}=?',
        whereArgs: [serviceId]
    );
  }

}

class ConferenceBookingDetailsTable{
  static const String tableName = "conference_booking_details";
  static const String id = "id";
  static const String bookingId = "bookingId";
  static const String date = "date";
  static const String startTime = "startTime";
  static const String endTime = "endTime";

  String sql =
  '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $bookingId TEXT NOT NULL,
    $date DATETIME NOT NULL,
    $startTime STRING NOT NULL,
    $endTime STRING NOT NULL,
    $id PRIMARY KEY
    )
  ''';
}