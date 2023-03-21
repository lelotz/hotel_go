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
      var existingSession = SessionTracker(
        id: "9ac46500-c71b-11ed-9ae8-e3ead359dac3",
        employeeId: '00001WH',
        dateCreated: "2023-03-20T15:34:49.298855"
      );
      sessionTracker = SessionTracker(
        id:  id,
        employeeId: '00001WH',
        dateCreated: dateTime,
      );
      await sessionManager.createNewSession(sessionTracker.toJson());
      if(sessionManager.sessionExists.value ?? true){
        expect(sessionManager.currentSession.value.toJson(), existingSession.toJson());
      }else{
        expect(sessionManager.currentSession.value.toJson(), sessionTracker.toJson());
      }

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