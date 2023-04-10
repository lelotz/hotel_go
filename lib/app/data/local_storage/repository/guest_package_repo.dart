import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/guest_package_model.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/values/localization/local_keys.dart';

class GuestPackageRepository extends SqlDatabase {
  Future<List<GuestPackage>> getStoredGuestPackageByRoomTransactionId(
      String roomTransaction) async {
    List<GuestPackage> storedPackages = [];
    await read(
        tableName: GuestPackageTable.tableName,
        where: '${GuestPackageTable.roomTransactionId}=?',
        whereArgs: [roomTransaction]).then((value) {
          if(value!=null && value.isNotEmpty){
            storedPackages = GuestPackage.fromJsonList(value);
          }
    });
    return storedPackages;
  }

  storeGuestPackage(GuestPackage guestPackage) async {
    await create(GuestPackageTable.tableName, guestPackage.toJson());
    await UserActivityRepository().createUserActivity(UserActivity(
            activityId: Uuid().v1().toString(),
            activityValue: guestPackage.value,
            activityStatus: LocalKeys.kPackage,
            description: LocalKeys.kStorePackage,
            roomTransactionId: guestPackage.roomTransactionId,
            guestId: guestPackage.guestId,
            employeeId: guestPackage.storedEmployeeId,
            employeeFullName: await AdminUserRepository()
                .getAdminUserById(guestPackage.storedEmployeeId!)
                .then((value) =>
                    AdminUser().fromJsonList(value ?? []).first.fullName),
            unit: guestPackage.unit,
            dateTime: guestPackage.dateStored)
        .toJson());
  }

  returnGuestPackage(GuestPackage guestPackage) async {
    await update(
        tableName: GuestPackageTable.tableName,
        row: guestPackage.toJson(),
        where: '${GuestPackageTable.id}=?',
        whereArgs: [guestPackage.id]);
    await UserActivityRepository().createUserActivity(UserActivity(
            activityId: Uuid().v1().toString(),
            activityValue: guestPackage.value,
            activityStatus: LocalKeys.kPackage,
            description: LocalKeys.kReturnPackage,
            guestId: guestPackage.guestId,
            roomTransactionId: guestPackage.roomTransactionId,
            employeeId: guestPackage.returnedEmployeeId,
            employeeFullName: await AdminUserRepository()
                .getAdminUserById(guestPackage.returnedEmployeeId!)
                .then((value) =>
                    AdminUser().fromJsonList(value ?? []).first.fullName),
            unit: guestPackage.unit,
            dateTime: guestPackage.dateStored)
        .toJson());
  }
}

class GuestPackageTable {
  static const String tableName = "guest_packages";
  static const String id = "id";
  static const String dateStored = "dateStored";
  static const String dateReturned = "dateReturned";
  static const String storedEmployeeId = "storedEmployeeId";
  static const String returnedEmployeeId = "returnedEmployeeId";
  static const String description = "description";
  static const String value = "value";
  static const String unit = "unit";
  static const String quantity = "quantity";
  static const String roomTransactionId = "roomTransactionId";
  static const String guestId = "guestId";

  String sql = '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $id TEXT PRIMARY KEY,
        $dateStored DATETIME NOT NULL,
        $dateReturned DATETIME,
        $storedEmployeeId TEXT,
        $returnedEmployeeId TEXT,
        $description TEXT NOT NULL,
        $unit TEXT,
        $value INT NOT NULL,
        $quantity INT NOT NULL,
        $roomTransactionId TEXT,
        $guestId TEXT NOT NULL )
      ''';
}
