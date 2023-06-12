import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../utils/date_formatter.dart';
class LocalLogger {
  LocalLogger._privateConstruct();
  static final LocalLogger instance =  LocalLogger._privateConstruct();
  static String defaultStoragePath = Platform.isWindows ? "Hotels_Go\\" : "Hotels_Go/";



  Future<String> getCurrentFilePath()async{
    String basePath = await directoryPath.then((value) => value!.path);
    return basePath + 'Logs\\${extractDate(DateTime.now())}\\' + 'crud_${extractDate(DateTime.now())}.txt';
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
    bool fileExists = await currentLogFile.exists() ? true : false;
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
    bool fileExists = await currentLogFile.exists() ? true : false;
    String prefix = '[${extractDate(DateTime.now())}][${extractTime(DateTime.now())}][${data['title']}]';
    String nextLine = fileExists ? '\n\n':'';
    String body = prefix + data.toString() + error + nextLine;

    await writeFile(
        body.codeUnits,
        filePath: filePath,
        append: fileExists ? true : false);
  }
}
