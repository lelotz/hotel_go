
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/client_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/conference_booking_details_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/encrypted_data_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/guest_package_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/hotel_issues_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/internal_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/other_transactions_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/petty_cash_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_data_repository.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_status_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/service_booking_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/shift_handover_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/status_manager_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';

/// This List of String contains the SQL scripts for creating SQL Tables
List<String> dbTablesSql = [
  AdminUsersTable().sql,
  ClientTable().sql,
  RoomStatusTable().sql,
  RoomsTable().sql,
  RoomTransactionsTable().sql,
  OtherTransactionsTable().sql,
  UserActivityTable().sql,
  CollectedPaymentsTable().sql,
  SessionTrackerTable().sql,
  SessionActivityTable().sql,
  EncryptedDataTable().sql,
  ServiceBookingTable().sql,
  PettyCashTable().sql,
  InternalTransactionTable().sql,
  HotelIssuesTable().sql,
  StatusManagerTable().sql,
  ShiftHandOverTable().sql,
  ConferenceBookingDetailsTable().sql,
  GuestPackageTable().sql,
];

















