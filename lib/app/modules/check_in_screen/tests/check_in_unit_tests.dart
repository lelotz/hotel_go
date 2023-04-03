import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/client_user_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/collected_payments_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_data_repository.dart';
import 'package:hotel_pms/app/data/local_storage/repository/room_transaction_repo.dart';
import 'package:hotel_pms/app/data/local_storage/repository/user_activity_repo.dart';
import 'package:hotel_pms/app/modules/check_in_screen/controller/check_in_form_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/guest_dashboard_controller.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/controller/payment_form_controller.dart';
import 'package:hotel_pms/app/modules/homepage_screen/controller/homepage_controller.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/values/localization/local_keys.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../mock_data/mock_data_api.dart';
import '../../../data/local_storage/innit_data.dart';

checkInControllerUnitTests() async {
  int checkInsToTest = 1;

  for (int i = 0; i < checkInsToTest; i++) {
    AuthController authController = Get.put(AuthController(isTest: true));
    if (i % 19 == 0) {
      authController.randomUserIndex = random(0, initAdminUsers.length);
    }
    authController.onInit();
    await authController.loginUser();

    HomepageController homepageController =
        Get.put(HomepageController(), permanent: true);
    await homepageController.onInit();
    homepageController.selectedRoom(homepageController
        .roomData.value[random(0, homepageController.roomData.value.length)]);
    bool roomIsOccupied =
        homepageController.selectedRoomData.value.roomStatus!.description ==
                LocalKeys.kOccupied
            ? true
            : false;

    CheckInFormController checkInFormController = CheckInFormController(
        isTest: true,
        isReport: true,
        roomNumber:
            homepageController.selectedRoomData.value.roomNumber.toString());
    // checkInFormController.selectedRoomData.value = homepageController.roomData.value[random(0, homepageController.roomData.value.length)];
    await checkInFormController.onInit();

    String nights = random(1, 10).toString();
    String paidToday = "0";

    if (i % 3 == 0 && i % 7 == 0) paidToday = "0";
    if (i % 2 == 0) paidToday = "10000";
    if (i % 5 == 0) paidToday = checkInFormController.roomCost.value.toString();
    checkInFormController.paidTodayCtrl.text = paidToday;
    checkInFormController.checkInDate.value = DateTime.now().add(Duration(
        days: random(0, 365), hours: random(0, 23), seconds: random(0, 60)));

    checkInFormController.nightsCtrl.text = nights;
    checkInFormController.stayCost();
    await checkInFormController.checkInGuest();

    GuestDashboardController guestDashboardController =
        Get.put(GuestDashboardController());
    await guestDashboardController.onInit();

    if (roomIsOccupied == false) {
      test('''Check-In Controller onInit Test''', () async {
        expect(checkInFormController.adultsCtrl.text, "1");
        expect(checkInFormController.childrenCtrl.text, "0");
        expect(checkInFormController.fullNameCtrl.text,
            mockNames[checkInFormController.mockNameIndex]);
        expect(checkInFormController.goingToCtrl.text,
            mockCountries[checkInFormController.mockCountriesIndex]);
        expect(checkInFormController.comingFromCtrl.text,
            mockCountries[checkInFormController.mockCountriesIndex]);
        expect(checkInFormController.idNumberCtrl.text.isNotEmpty, true);
        expect(checkInFormController.idTypeCtrl.text, "PASSPORT");
        expect(checkInFormController.countryOfBirthCtrl.text,
            mockCountries[checkInFormController.mockCountriesIndex]);
        expect(checkInFormController.nightsCtrl.text, nights);
        expect(checkInFormController.paidTodayCtrl.text, paidToday);
      });

      test('''Check-In Controller CHECK-IN test''', () async {
        bool checkExistenceOnly = checkInsToTest >= 3 ? false : false;

        await verifyCheckInArtifact(CheckInArtifactsKeys.clientId,
            checkInFormController.checkInArtifacts,
            checkExistenceOnly: checkExistenceOnly);
        await verifyCheckInArtifact(CheckInArtifactsKeys.roomTransactions,
            checkInFormController.checkInArtifacts,
            checkExistenceOnly: checkExistenceOnly);
        await verifyCheckInArtifact(CheckInArtifactsKeys.roomData,
            checkInFormController.checkInArtifacts,
            checkExistenceOnly: checkExistenceOnly);
        await verifyCheckInArtifact(CheckInArtifactsKeys.collectedPaymentId,
            checkInFormController.checkInArtifacts,
            skip: checkInFormController.paidTodayCtrl.text == "0" ? true : false,
            checkExistenceOnly: checkExistenceOnly);
        await verifyCheckInArtifact(CheckInArtifactsKeys.employeeId,
            checkInFormController.checkInArtifacts,
            checkExistenceOnly: checkExistenceOnly);
        await verifyCheckInArtifact(CheckInArtifactsKeys.clientActivity,
            checkInFormController.checkInArtifacts,
            checkExistenceOnly: checkExistenceOnly);
        // AppLogger.instance.logger.wtf('\r $i/$checkInsToTest');

        if (guestDashboardController.paymentDataController.roomTransaction.value
                .outstandingBalance == 0
            ) {
          await guestDashboardController.checkOutGuest();
        } else {
          PaymentController paymentController = Get.put(PaymentController());
          await paymentController.onInit();
          paymentController.selectBill(LocalKeys.kAll);
          await paymentController.payBill();
          await guestDashboardController.checkOutGuest();
        }
      });

      if (i % 19 == 0) {
        await authController.logOutUser();
        Get.delete<AuthController>();
      }
    } else {
      if (guestDashboardController
              .paymentDataController.roomTransaction.value.outstandingBalance ==
          0) {
        await guestDashboardController.checkOutGuest();
      } else {
        PaymentController paymentController = Get.put(PaymentController());
        await paymentController.onInit();
        paymentController.selectBill(LocalKeys.kAll);
        await paymentController.payBill();
        await guestDashboardController.checkOutGuest();
      }
    }


    Get.delete<HomepageController>();
    Get.delete<GuestDashboardController>();
    Get.delete<CheckInFormController>();
    Get.delete<PaymentController>();
  }
}

Future<void> verifyCheckInArtifact(
    String artifactKey, Map<String, dynamic> artifacts,
    {bool skip = false, bool checkExistenceOnly = false}) async {
  switch (artifactKey) {
    case CheckInArtifactsKeys.clientId:
      {
        await ClientUserRepository()
            .getClientUser(artifacts[artifactKey])
            .then((value) {
          if (value != null) {
            expect(value.length, 1);
            if (checkExistenceOnly == false) {
              expect(artifacts['${artifactKey}value'], value.first);
            }
          }
        });
      }
      break;

    case CheckInArtifactsKeys.roomTransactions:
      {
        await RoomTransactionRepository()
            .getRoomTransaction(artifacts[artifactKey])
            .then((value) {
          if (value != null) {
            expect(value.length, 1);
            if (checkExistenceOnly == false) {
              expect(artifacts['${artifactKey}value'], value.first);
            }
          }
        });
      }
      break;

    case CheckInArtifactsKeys.collectedPaymentId:
      {
        if (skip == false) {
          await CollectedPaymentsRepository()
              .getCollectedPaymentsById(artifacts[artifactKey])
              .then((value) {
            if (value != null) {
              expect(value.length, 1);
              if (checkExistenceOnly == false) {
                expect(artifacts['${artifactKey}value'], value.first.toJson());
              }
            }
          });
        }
      }
      break;

    case CheckInArtifactsKeys.roomData:
      {
        await RoomDataRepository()
            .getRoom(artifacts[artifactKey])
            .then((value) {
          expect(value.roomNumber! > 0, true);
          if (checkExistenceOnly == false) {
            expect(artifacts['${artifactKey}value'], value.toJson());
          }
        });
      }
      break;

    case CheckInArtifactsKeys.employeeId:
      {
        await AdminUserRepository()
            .getAdminUserById(artifacts[artifactKey])
            .then((value) {
          if (value != null) {
            expect(value.length, 1);
            if (checkExistenceOnly == false) {
              expect(artifacts['${artifactKey}value'], value.first);
            }
          }
        });
      }
      break;

    case CheckInArtifactsKeys.clientActivity:
      {
        await UserActivityRepository()
            .getUserActivityByActivityId(artifacts[artifactKey])
            .then((value) {
          if (value != null) {
            expect(value.length, 1);
            if (checkExistenceOnly == false) {
              expect(artifacts['${artifactKey}value'], value.first);
            }
          }
        });
      }
      break;
  }
}
