
import 'package:hotel_pms/app/data/local_storage/repository/admin_user_repo.dart';
import 'package:hotel_pms/app/modules/login_screen/views/confirm_current_session_popup.dart';
import 'package:hotel_pms/app/modules/user_data/controller/user_data_controller.dart';

import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:logger/logger.dart';

import '../../app/data/local_storage/repository/session_management_repo.dart';
import '../../app/modules/homepage_screen/views/homepage_view.dart';
import '../logs/logger_instance.dart';

class SessionManager extends GetxController {
  Logger logger = AppLogger.instance.logger;
  Rx<SessionTracker> currentSession = Rx<SessionTracker>(SessionTracker());
  Rx<List<SessionTracker>> rogueSessions = Rx<List<SessionTracker>>([]);
  Rx<String> currentUserId = ''.obs;
  Map rogueSessionNames = {};

  Rx<bool> sessionExists = false.obs;
  bool isTest = false;
  UserData userData = Get.find<UserData>();

  SessionManager({this.isTest = false});

  /// Creates a new session if
  /// 1. A session older than 8 hours and created on the same day exists
  /// 2. Current Session is empty
  validateNewSession(String userId) async {
    currentUserId.value = userId;

    /// Search for existing sessions
    await getRougeSessions(userId);

    if (rogueSessions.value.length > 0) {
      buildDialog(Get.context!, '', ConfirmCurrentSession(),);
      logger.i('Confirming current Session');
    } else {
      await setCurrentSession(userId: userId);
    }
  }

  linkRogueSessionIdsToEmployeeNames()async{
    for(SessionTracker session in rogueSessions.value){
      String employeeName = userData.userData.value[session.employeeId!];
      rogueSessionNames.addAll({session.employeeId:employeeName});
    }
  }

  setCurrentSession(
      {SessionTracker? fromExistingSession, String? userId}) async {
    if (fromExistingSession != null && fromExistingSession.id != null) {
      await createSession(existingSession: fromExistingSession.toJson(), isNewSession: false);
      rogueSessions.value.remove(fromExistingSession);
      await updateRogueSessions(rogueSessions.value, fromExistingSession.employeeId!);

    } else if(userId!=null){
      await createSession(userId: userId);
      await updateRogueSessions(rogueSessions.value, userId);

    }

    if (currentSession.value.sessionStatus != null &&
        currentSession.value.sessionStatus == SessionStatusTypes.instance.currentSession) {
      Get.to(() => HomePageView());
    }
  }

  createSession(
      {Map<String, dynamic>? existingSession,
      bool isNewSession = true,
      String? userId}) async {
    Map<String, dynamic> newSession = SessionTracker(
            id: const Uuid().v1(),
            employeeId: userId,
            dateCreated: DateTime.now().toIso8601String(),
            sessionStatus: SessionStatusTypes.instance.currentSession)
        .toJson();
    await SessionManagementRepository()
        .createNewSessionTracker(isNewSession ? newSession : existingSession!)
        .then((value) {
      if (value != null) {
        currentSession.value = SessionTracker.fromJson(
            isNewSession ? newSession : existingSession!);
      }
    });
    logger.i(
        'created session from ${isNewSession ? 'newSession' : 'existingSession'}');
  }

  Future<SessionTracker?> updateRogueSessions(
      List<SessionTracker> rogueSessions, String attemptingUserId) async {
    SessionTracker validExistingSession = SessionTracker();

    for (SessionTracker session in rogueSessions) {
      if (session.employeeId == attemptingUserId &&
          currentSession.value.id != session.id) {
        session.dateEnded = DateTime.now().toIso8601String();
        session.sessionStatus = SessionStatusTypes.instance.expiredSession;
        await SessionManagementRepository().updateSessionTracker(session.toJson());
      }
    }

    return validExistingSession;
  }

  getRougeSessions(String userId) async {
    rogueSessions.value.clear();
    await SessionManagementRepository()
        .getSessionByEmployeeIdAndSessionStatus(userId,SessionStatusTypes.instance.currentSession)
        .then((value) async {
      if (value.isNotEmpty) {
        for (SessionTracker session in value) {
          if (session.dateEnded == null &&
              session.sessionStatus ==
                  SessionStatusTypes.instance.currentSession
              ) {
            rogueSessions.value.add(session);
          }else if(DateTime.parse(session.dateCreated!)
              .difference(DateTime.now())
              .inHours >
              13){
            updateRogueSessions([session], userId);
          }
        }
        rogueSessions.refresh();
      }
      await linkRogueSessionIdsToEmployeeNames();

      logger.i('rogue sessions detected: ${rogueSessions.value.length}');
    });
  }

  Future<bool> getExistingOpenSession(String userId) async {
    bool sessionExists = false;

    await SessionManagementRepository()
        .getSessionByStatus(SessionStatusTypes.instance.currentSession)
        .then((value) async {
      if (value.isNotEmpty) {
        logger.w({'rogue sessions detected': value.length});
        rogueSessions.value = value;
        currentSession.value =
            await updateRogueSessions(value, userId) ?? SessionTracker();
        if (currentSession.value.id != null) {
          sessionExists = true;
          logger.i({'sessionExists': currentSession.value.toJson()});
        }
      }
    });

    return sessionExists;
  }

  updateSessionTracker() async {
    if (isTest) {
      currentSession.value.dateEnded =
          DateTime.parse(currentSession.value.dateCreated!)
              .add(const Duration(hours: 8))
              .toIso8601String();
    } else {
      currentSession.value.dateEnded = DateTime.now().toIso8601String();
    }
    currentSession.value.sessionStatus =
        SessionStatusTypes.instance.expiredSession;
    await SessionManagementRepository()
        .updateSessionTracker(currentSession.value.toJson());
    //logger.i({'updatedSessionAtLogOff':currentSession.value.toJson()});
  }

  recordSessionTransaction(String transactionId, String transactionType) async {
    await SessionManagementRepository().createNewSessionActivity(
        SessionActivity(
                id: const Uuid().v1(),
                sessionId: currentSession.value.id,
                transactionId: transactionId,
                transactionType: transactionType,
                dateTime: DateTime.now().toIso8601String())
            .toJson());
  }
}
