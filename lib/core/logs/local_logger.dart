import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/date_formatter.dart';
class LocalLogger extends LogPrinter{
  LocalLogger._privateConstruct();
  static final LocalLogger instance =  LocalLogger._privateConstruct();
  static String defaultStoragePath = Platform.isWindows ? "Hotels_Go\\" : "Hotels_Go/";


  Future<String> getCurrentFilePath()async{
    String basePath = await directoryPath.then((value) => value!.path);
    return basePath + 'Logs\\${extractDate(DateTime.now())}\\' + 'crud_${extractDate(DateTime.now())}.txt';
  }

  Future<String> getCurrentEventsFilePath(String level)async{
    String basePath = await directoryPath.then((value) => value!.path);
    return basePath + 'Events\\${extractDate(DateTime.now())}\\' + '${level}_${extractDate(DateTime.now())}.txt';

  }

  Future<Directory?> get directoryPath async{
    Directory? directory = Directory('');
    String appDirectory = '';
    try{
      // defining directory for file
      directory = await getApplicationDocumentsDirectory();
      appDirectory = '${directory.path}\\$defaultStoragePath';
      directory = Directory(appDirectory);
    }catch(e){
      appDirectory = "C:\\";
      directory = Directory(appDirectory);

      return directory;
    }
    return directory;

  }

  Future<File> getNewFile(String path)async{
    late File file;
    try{
      file = await File(path).create(recursive: true);
    }catch (e){

      // Log.exportLog(data: {'title':'getNewFile error: ${path}'}, error: e.toString());

    }
    return file;
  }

  Future<File> writeFile(List<int> bytes,{required String filePath,FileMode fileMode = FileMode.write,bool append=false})async{
    File file = File(filePath);
    try{
      file = await file.writeAsBytes(bytes, flush: true,mode: append ? FileMode.append : FileMode.write );
    }catch (otherError){

    }
    return file;
  }

  exportSqlLog({required Map<String,dynamic> data,required String error})async{
    String filePath = await getCurrentFilePath();
    File currentLogFile = await getNewFile(filePath);
    bool fileExists = await currentLogFile.exists();
    String prefix = '[${extractDate(DateTime.now())}][${extractTime(DateTime.now())}][${data['title']}][${data['tableName']}]';
    String nextLine = fileExists ? '\n\n':'';
    String body = prefix + data.toString() + error + nextLine;

    await writeFile(
        body.codeUnits,
        filePath: filePath,
        append: fileExists ? true : false);
  }

  /// The map data can have any keys
  /// data[]
  exportLog({required Map<String,dynamic> data,required String error})async{
    String filePath = await getCurrentFilePath();
    File currentLogFile = await getNewFile(filePath);
    bool fileExists = await currentLogFile.exists();
    String prefix = '[${extractDate(DateTime.now())}][${extractTime(DateTime.now())}][${data['title']}]';
    String nextLine = fileExists ? '\n\n':'';
    String body = prefix + data.toString() + error + nextLine;

    await writeFile(
        body.codeUnits,
        filePath: filePath,
        append: fileExists ? true : false);
  }

  String formatLogEvent(LogEvent event){
    String head = '[${event.time.toIso8601String()}]\n';
    String title = '[MESSAGE]\n'+event.message.toString() + '\n';
    String error =  '[ERROR]\n'+event.error.toString() + '\n';
    String trace = '[TRACE]\n'+event.stackTrace.toString();
    switch(event.level){
      case Level.error : return head+title+error+trace+'\nend_of_event\n\n';
      //case Level.warning : return head+title+error+trace+'\nend_of_event\n\n';
      default : return head+title+'\nend_of_event\n\n';
    }
  }

  exportEventLogs(LogEvent event)async{
    String filePath = await getCurrentEventsFilePath(event.level.name);
    String line = formatLogEvent(event);
    File currentLogFile = await getNewFile(filePath);
    await writeFile(
        line.codeUnits,
        filePath: filePath,
        append: await currentLogFile.exists());
  }

  Future<Map<String, dynamic>> readJsonFile(String filePath) async {
    String? fileContent;
    // Creating a file
    File file = File(filePath);

    //check if file exists
    if (await file.exists()) {
      try {
        // reading the file and saving it as a String
        fileContent = await file.readAsString();

      } catch (e) {
        exportLog(data: {'data':'error reading json file ' + filePath}, error: e.toString());
      }
    }
    // decoding Json string fileContent into a map
    // It will be converted to a User model
    return json.decode(fileContent ?? "{'key':'value'}");
  }



  @override
  List<String> log(LogEvent event) {
    exportEventLogs(event);
    return [];
  }
}
