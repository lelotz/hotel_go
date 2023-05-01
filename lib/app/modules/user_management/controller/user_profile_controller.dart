import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/guest_package_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/other_transactions_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/app/data/models_n/collect_payment_model.dart';
import 'package:hotel_pms/app/data/models_n/guest_package_model.dart';
import 'package:hotel_pms/app/data/models_n/other_transactions_model.dart';
import 'package:hotel_pms/app/data/models_n/room_transaction.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:hotel_pms/app/data/models_n/user_activity_model.dart';
import 'package:hotel_pms/app/modules/user_management/controller/user_management_controller.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:logger/logger.dart';
import '../../../data/models_n/service_booking_model.dart';


class UserProfileController extends GetxController{
  Logger logger = AppLogger.instance.logger;
  Rx<AdminUser> adminUser = Get.find<UserManagementController>().selectedUser;

  /// User Activity
  Rx<List<UserActivity>> userActivity = Rx<List<UserActivity>>([]);
  Rx<List<UserActivity>> paginatedUserActivity = Rx<List<UserActivity>>([]);

  /// Room Transactions
  Rx<List<RoomTransaction>> employeeRoomTransactions = Rx<List<RoomTransaction>>([]);
  Rx<List<RoomTransaction>> paginatedEmployeeRoomTransactions = Rx<List<RoomTransaction>>([]);

  /// Room Service
  Rx<List<OtherTransactions>> employeeRoomServiceActivity = Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> paginatedEmployeeRoomServiceActivity = Rx<List<OtherTransactions>>([]);

  /// Bookings
  Rx<List<ServiceBooking>> employeeServiceBookingActivity = Rx<List<ServiceBooking>>([]);
  Rx<List<ServiceBooking>> paginatedEmployeeServiceBookingActivity = Rx<List<ServiceBooking>>([]);

  /// Collected Payments
  Rx<List<CollectPayment>> employeeCollectedPaymentsActivity = Rx<List<CollectPayment>>([]);
  Rx<List<CollectPayment>> paginatedEmployeeCollectedPaymentsActivity = Rx<List<CollectPayment>>([]);

  /// Laundry
  Rx<List<OtherTransactions>> employeeLaundryActivity = Rx<List<OtherTransactions>>([]);
  Rx<List<OtherTransactions>> paginatedEmployeeLaundryActivity = Rx<List<OtherTransactions>>([]);

  /// Laundry && Room Service
  Rx<List<OtherTransactions>> employeeOtherTransactions = Rx<List<OtherTransactions>>([]);

  /// Packages
  Rx<List<GuestPackage>> employeePackageStorageActivity = Rx<List<GuestPackage>>([]);
  Rx<List<GuestPackage>> paginatedEmployeePackageStorageActivity = Rx<List<GuestPackage>>([]);

  /// Sessions
  Rx<List<SessionTracker>> employeeSessionsTrackerActivity = Rx<List<SessionTracker>>([]);
  Rx<List<SessionTracker>> paginatedEmployeeSessionsTrackerActivity = Rx<List<SessionTracker>>([]);

  /// Sessions Activity
  Rx<List<SessionActivity>> employeeSessionActivity = Rx<List<SessionActivity>>([]);
  Rx<List<SessionActivity>> paginatedEmployeeSessionActivity = Rx<List<SessionActivity>>([]);






  Rx<String> employeeKeyMetricTitle = "".obs;

  @override
  onInit()async{
    super.onInit();
    await loadEmployeeTransactions();
  }


  updateUI(){
    update();
  }

  loadEmployeeTransactions()async{
    await loadUserActivity();
    await loadEmployeeRoomTransactions();
    await loadEmployeeBookedServices();
    await loadEmployeeCollectedPayments();
    await loadEmployeeOtherTransactions();
    await loadEmployeePackageTransactions();
    await loadEmployeeSessions();
    setEmployeeKeyMetricTitle();
    updateUI();
    displayLoadedDataLogs();
  }

  displayLoadedDataLogs(){
    logger.i('UserActivity : ${userActivity.value.length}');
    logger.i('CollectedPayments ${employeeCollectedPaymentsActivity.value.length}');
    logger.i('RoomTransactions ${employeeRoomTransactions.value.length}');
    logger.i('Laundry ${employeeLaundryActivity.value.length}');


  }

  loadUserActivity()async{
    userActivity.value.clear();
    userActivity.value = await UserActivityRepository().getUserActivityByUserId(adminUser.value.id!);
    userActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch)
    );
    updateUI();
  }


  loadEmployeeRoomTransactions()async{
    employeeRoomTransactions.value = await RoomTransactionRepository().
      getRoomTransactionsByEmployeeId(id: adminUser.value.id);
    employeeRoomTransactions.value.sort(
            (a,b)=> DateTime.parse(b.date!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.date!).millisecondsSinceEpoch));
  }

  loadEmployeeOtherTransactions()async{
    employeeOtherTransactions.value = await OtherTransactionsRepository().getOtherTransactionsByEmployeeId(id: adminUser.value.id);
    sortEmployeeOtherTransactions();
  }
  
  sortEmployeeOtherTransactions(){
    for(OtherTransactions element in employeeOtherTransactions.value){
      employeeLaundryActivity.value.addIf(element.paymentNotes=='LAUNDRY', element);
      employeeRoomServiceActivity.value.addIf(element.paymentNotes=='Room Service', element);
    }
    employeeLaundryActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
    employeeRoomServiceActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch));
  }
  loadEmployeePackageTransactions()async{
    employeePackageStorageActivity.value = await GuestPackageRepository().getStoredGuestPackageByEmployeeId(id: adminUser.value.id);
    employeePackageStorageActivity.value.sort((a,b)=> DateTime.parse(b.dateStored!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateStored!).millisecondsSinceEpoch)
    );
  }
  loadEmployeeCollectedPayments()async{
    employeeCollectedPaymentsActivity.value = await CollectedPaymentsRepository().getCollectedPaymentsByEmployeeId(id: adminUser.value.id);
    employeeCollectedPaymentsActivity.value.sort((a,b)=> DateTime.parse(b.dateTime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateTime!).millisecondsSinceEpoch)
    );
  }

  loadEmployeeBookedServices()async{
      employeeServiceBookingActivity.value = await ServiceBookingRepository().getServiceBookingByEmployeeId(id: adminUser.value.id);
      employeeServiceBookingActivity.value.sort( (a,b)=> DateTime.parse(b.bookingDatetime!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.bookingDatetime!).millisecondsSinceEpoch)
      );
  }

  loadEmployeeSessions()async{
    employeeSessionsTrackerActivity.value = await SessionManagementRepository().getSessionTrackersByEmployeeId(id: adminUser.value.id);
    employeeSessionsTrackerActivity.value.sort((a,b)=> DateTime.parse(b.dateCreated!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.dateCreated!).millisecondsSinceEpoch));
  }

  loadEmployeeSessionActivity()async{

  }

  setEmployeeKeyMetricTitle(){
    if(adminUser.value.position == AppConstants.userRoles[600]){
      employeeKeyMetricTitle.value = 'Rooms & Laundry Tasks';
    }else{
      employeeKeyMetricTitle.value = 'Rooms Sold';
    }
  }

  updateAccountStatus(String status)async{
    adminUser.value.status = status;
    AdminUserRepository().updateAdminUser(adminUser.value.toJson());
    adminUser.refresh();
  }




}