import 'dart:async';
import 'dart:io';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/date_formatter.dart';
class LocalLogger {
  LocalLogger._privateConstruct();
  static final LocalLogger instance =  LocalLogger._privateConstruct();
  FileManager fileManager = FileManager();

  Future<String> getCurrentFilePath()async{
    String basePath = await fileManager.directoryPath.then((value) => value!.path);
    return basePath + 'Logs\\${extractDate(DateTime.now())}\\' + 'crud_${extractDate(DateTime.now())}.txt';
  }

  exportLog({required Map<String,dynamic> data,required String error})async{
    String filePath = await getCurrentFilePath();
    File currentLogFile = await fileManager.getNewFile(filePath);
    bool fileExists = await currentLogFile.exists() ? true : false;
    String prefix = '[${extractDate(DateTime.now())}][${extractTime(DateTime.now())}][${data['title']}][${data['tableName']}]';
    String nextLine = fileExists ? '\n':'';
    String body = prefix + data.toString() + error + nextLine;

    await fileManager.writeFile(
        body.codeUnits,
        filePath: filePath,
        append: fileExists ? true : false);
  }
}
