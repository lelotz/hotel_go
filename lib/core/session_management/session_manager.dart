import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/models_n/session_activity_model.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:logger/logger.dart';

import '../../app/data/local_storage/repository/session_management_repo.dart';
import '../logs/logger_instance.dart';

class SessionManager extends GetxController{
  Logger logger = AppLogger.instance.logger;
  Rx<SessionTracker> currentSession = Rx<SessionTracker>(SessionTracker());
  Rx<bool> sessionExists = false.obs;
  bool isTest = false;
  SessionManager({this.isTest=false});

  /// Creates a new session if
  /// 1. A session older than 8 hours and created on the same day exists
  /// 2. Current Session is empty
  Future<String?> createNewSession(String userId)async{
    Map<String,dynamic> sessionTrackerMap = SessionTracker(
      id: const Uuid().v1(),
      employeeId: userId,
      dateCreated: DateTime.now().toIso8601String(),
      sessionStatus: SessionStatusTypes.instance.currentSession
    ).toJson();

    /// Search for existing session
    sessionExists.value = await getExistingOpenSession(userId);

    if(sessionExists.value == false){
      /// Create currentSession
      await SessionManagementRepository().createNewSessionTracker(sessionTrackerMap).then((value) {
        if (value != null) {
          currentSession.value = SessionTracker.fromJson(sessionTrackerMap);
        }
      });
    }

    return currentSession.value.id;
  }


  Future<SessionTracker?> updateRogueSessions(List<SessionTracker> rogueSessions, String attemptingUserId)async{
    SessionTracker validExistingSession = SessionTracker();
    for(SessionTracker session in rogueSessions){
      if(session.employeeId == attemptingUserId &&
          isTimeDifferenceLessOrEqualTo(DateTime.parse(session.dateCreated!),DateTime.now(),9)){
        validExistingSession = session;
        //logger.i({'using existing session': validExistingSession.toJson()});
      }else {
        session.dateEnded = DateTime.now().toIso8601String();
        session.sessionStatus = SessionStatusTypes.instance.expiredSession;
        await SessionManagementRepository().updateSessionTracker(session.toJson());
      }
    }

    return validExistingSession;
  }

  Future<bool> getExistingOpenSession(String userId)async {
    bool sessionExists = false;

    await SessionManagementRepository().getSessionByStatus(SessionStatusTypes.instance.currentSession).then((value) async{
      if(value.isNotEmpty){
        //logger.w({'rogue sessions detected': value.length});
        currentSession.value = await updateRogueSessions(value, userId) ?? SessionTracker();
        if(currentSession.value.id != null) {
          sessionExists = true;
          //logger.i({'sessionExists': currentSession.value.toJson()});
        }
      }
    });

    return sessionExists;

  }


  updateSessionTracker()async{
    if(isTest){
      currentSession.value.dateEnded = DateTime.parse(currentSession.value.dateCreated!).add(const Duration(hours: 8)).toIso8601String();
    }else{
      currentSession.value.dateEnded = DateTime.now().toIso8601String();
    }
    currentSession.value.sessionStatus = SessionStatusTypes.instance.expiredSession;
    await SessionManagementRepository().updateSessionTracker(currentSession.value.toJson());
    //logger.i({'updatedSessionAtLogOff':currentSession.value.toJson()});

  }

  recordSessionTransaction(String transactionId,String transactionType)async{
    await SessionManagementRepository().createNewSessionActivity(
        SessionActivity(
          id: const Uuid().v1(),
          sessionId: currentSession.value.id,
          transactionId: transactionId,
          transactionType: transactionType

    ).toJson());
  }

}