import 'package:hotel_pms/app/data/local_storage/repository/session_management_repo.dart';
import 'package:hotel_pms/app/data/models_n/session_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/session_management/session_manager.dart';

void sessionManagerUnitTest(){
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
      String sessionId = await sessionManager.createNewSession(sessionTracker.toJson()) ?? '';
       await SessionManagementRepository().getSessionTracker(sessionId,currentSession: true).then((value) {
        if(value.isNotEmpty && value.length == 1) createdSessionInStorage = value[0];
      });
      expect(sessionManager.currentSession.value.toJson(), createdSessionInStorage.toJson());
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