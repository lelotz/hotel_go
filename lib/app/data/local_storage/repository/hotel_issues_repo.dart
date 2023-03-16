
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';

import '../../models_n/hotel_issues_model.dart';

class HotelIssuesRepository extends SqlDatabase{
  HotelIssuesRepository();

  Future<int?> createHotelIssue(Map<String,dynamic> row) async {
    return await create(HotelIssuesTable.tableName, row);
  }
  Future<HotelIssues> getHotelIssue(String issueId)async{
    HotelIssues issue = HotelIssues();
    await read(
      tableName: HotelIssuesTable.tableName,
      where: '${HotelIssuesTable.id}=?',
      whereArgs: [issueId]
    ).then((value) {
      if(value!= null && value.isNotEmpty) issue = HotelIssues.fromJson(value[0]);
    });
    return issue;
  }
  Future<List<HotelIssues>> getMultipleHotelIssues(List<String> issueIds)async{
    List<HotelIssues> result =[];
    await readMultipleRows(
      tableName: HotelIssuesTable.tableName,
      where: '${HotelIssuesTable.id} IN(${buildNQuestionMarks(issueIds.length)})',
      whereArgs: buildWhereArgsFromList(issueIds)
    ).then((value) {
      result.addAll(HotelIssues().fromJsonList(value ?? []));
    });
    return result;
  }


}

class HotelIssuesTable{
  static const String tableName = "hotel_issues";
  static const String id = "id";
  static const String employeeId = "employeeId";
  static const String roomNumber = "roomNumber";
  static const String dateTime = "dateTime";
  static const String issueDescription = "issueDescription";
  static const String stepsTaken = "stepsTaken";
  static const String issueStatus = "issueStatus";
  static const String issueType = "issueType";

  String sql =
  '''
        CREATE TABLE IF NOT EXISTS $tableName(
        $roomNumber INT,
        $dateTime TEXT NOT NULL,
        $issueDescription TEXT NOT NULL,
        $stepsTaken TEXT,
        $issueStatus TEXT NOT NULL,
        $issueType TEXT NOT NULL,
        $id TEXT PRIMARY KEY,
        $employeeId TEXT NOT NULL )
      ''';


}