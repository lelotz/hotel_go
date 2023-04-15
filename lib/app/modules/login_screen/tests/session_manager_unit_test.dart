import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/session_management/session_manager.dart';

Future<void> sessionManagerUnitTest()async{
  print("session manager testing");
  final sessionManager = SessionManager();
  SessionTracker sessionTracker = SessionTracker();
  test(
      '''Test the state of the SessionManager reactive components. 
      Namely bool[sessionExists], SessionTracker[currentSession] at Init''', (){
    expect(sessionManager.sessionExists.value, false);
    expect(sessionManager.currentSession.value.toJson(), sessionTracker.toJson());
   }
  );



  test(
    '''Testing the creation of a new session using SessionTracker''', ()async{
      final id = const Uuid().v1();
      final dateTime = DateTime.now().toIso8601String();
      SessionTracker createdSessionInStorage = SessionTracker();

      sessionTracker = SessionTracker(
        id:  id,
        employeeId: '00001WH',
        dateCreated: dateTime,
      );
      String sessionId = await sessionManager.validateNewSession(sessionTracker.employeeId!) ?? '';
       await SessionManagementRepository().getSessionTracker(sessionId).then((value) {
        if(value.isNotEmpty && value.length == 1 && value.first.sessionStatus==SessionStatusTypes.instance.currentSession) {
          createdSessionInStorage = value[0];
        }
        expect(sessionManager.currentSession.value.toJson(), createdSessionInStorage.toJson());
      });

    }
  );

  test('''Testing updating sessionTracker''', () async{
      await sessionManager.updateSessionTracker();
      sessionTracker = sessionManager.currentSession.value;
      sessionTracker.dateEnded = sessionManager.currentSession.value.dateEnded;
      expect(sessionManager.currentSession.value.toJson(),sessionTracker.toJson());
  });

  test('''''',()async{});
  Get.delete<SessionManager>();

}