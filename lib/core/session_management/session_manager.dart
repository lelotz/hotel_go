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
  Future<String?> createNewSession(Map<String,dynamic> element)async{

    /// Search for existing session
    sessionExists.value = await getExistingOpenSession(element);
    sessionExists.refresh();

    if(sessionExists.value == false){
      /// Create currentSession
      await SessionManagementRepository().createNewSessionTracker(element).then((value) {
        if (value != null) {
          currentSession.value = SessionTracker.fromJson(element);
        }
      });
      await setCurrentSessionToStorage(element);
    }

    return currentSession.value.id;
  }

  Future<bool> getExistingOpenSession(Map<String,dynamic> element)async {
    bool sessionExists = false;
    if (element['employeeId'] != null) {
      await SessionManagementRepository().getSessionByEmployeeIdAndDate(
          element['employeeId'], DateTime.now().toIso8601String(),
          currentSession: true).then((value) async {
        if (value != null && value.length == 1) {
          currentSession.value = SessionTracker.fromJson(value[0]);
          logger.i({
            "title": "Found existing session with today's date",
            "data": value[0]
          });
          sessionExists = true;
        } else if (value != null && value.length > 1) {
          logger.wtf({
            'title': 'More than one session was found which means the last session was not logged out',
            'actions': ''
          });
        }
      });

    }
    return sessionExists;
  }

  setCurrentSessionToStorage(Map<String,dynamic> sessionTrackerMap)async{
    await SessionManagementRepository().getCurrentSession().then((value)async {
      if(value.isNotEmpty) await SessionManagementRepository().deleteCurrentSession();
    });

    await SessionManagementRepository().createNewSessionTracker(sessionTrackerMap,currentSession: true).then((value) {
      if (value != null) {
        currentSession.value = SessionTracker.fromJson(sessionTrackerMap);
      }
    });
  }

  updateSessionTracker()async{
    if(isTest){
      currentSession.value.dateEnded = DateTime.parse(currentSession.value.dateCreated!).add(const Duration(hours: 8)).toIso8601String();
    }else{
      currentSession.value.dateEnded = DateTime.now().toIso8601String();
    }

    await SessionManagementRepository().updateSessionTracker(currentSession.value.toJson()).then((value) {});

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