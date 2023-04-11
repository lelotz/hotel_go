import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/logs/logger_instance.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/useful_math.dart';


class FileManager{
  static FileManager? _instance;
  static String defaultStoragePath = Platform.isWindows ? "Hotels_Go\\" : "Hotels_Go/";
  Logger logger = AppLogger.instance.logger;

  FileManager._internal(){
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();


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
      if(appDirectory != directory.path) logger.e({'error':'Failed to get app directory','defaultDirectory': appDirectory},e);
      return directory;
    }
    return directory;

  }


  createFolder(String path)async{

    Directory? appDir  = await directoryPath;
    Directory directory = Directory('${appDir!.path}\\$path');
    try{
      if(appDir.path.isNotEmpty && await directory.exists() == false) {
        directory.create();
      } else {

      }
    }catch(e){
      logger.e(e);
    }

  }

  Future<File> writeFile(List<int> bytes,{required String filePath,FileMode fileMode = FileMode.write,bool append=false})async{
    File file = File(filePath);
    try{
      file = await file.writeAsBytes(bytes, flush: true,mode: append ? FileMode.append : FileMode.write );
    }on PathNotFoundException catch(e) {
      logger.e({'':'writeFile','pathNotFound': filePath}, e);
    }catch (otherError){
      logger.e({'':'writeFile','otherErrors': filePath}, otherError);
    }
    return file;
  }

  Future<String> getAppStorageDirectory()async{
    Directory? directory;
    directory = await directoryPath;
    return '${directory!.path}\\' ;
  }

  Future<File> getNewFile(String path)async{
    late File file;
    try{
      file = await File(path).create(recursive: true);
    }catch (e){
      logger.e('',e);
    }
    return file;
  }

  Future<String> generateFileName({String userName="system",String category="none"}) async {
    createFolder(category);
    String subfolder =
    extractDate(DateTime.now())
        .replaceAll('-', '_');
    String fileName = userName;
    fileName = fileName.replaceAll(' ', '');
    fileName = '${fileName}_$subfolder' '_${category}_';
    await FileManager().createFolder("$category\\$subfolder");
    fileName = fileName + random(0, 1024).toString(); //
    return "$category\\$subfolder\\$fileName";
  }




  Future<Map<String, dynamic>> readJsonFile(String filePath) async {
    String? fileContent;

    String appDirectory = await getAppStorageDirectory();
    // Creating a file
    File file = File(appDirectory + filePath);

    //check if file exists
    if (await file.exists()) {
      try {
        // reading the file and saving it as a String
        fileContent = await file.readAsString();
      } catch (e) {
        logger.e({'error':'reading jsonFile'},e.toString());
      }
    }
    // decoding Json string fileContent into a map
    // It will be converted to a User model
    return json.decode(fileContent!);
  }

  dynamic writeJsonFile(dynamic data,String path) async {
    File file = File(path);
    await file.writeAsString(json.encode(data));
    return data;
  }

}

Future<void> logTest ()async{
  FileManager fileManager = FileManager();
  String baseDirectory = await fileManager.directoryPath.then((value) => value!.path);
  String logFileName = 'roomTransactions_'+ extractDate(DateTime.now())+'.txt';
  String logPath = 'Logs\\${extractDate(DateTime.now())}\\';
  await fileManager.createFolder(logPath);
  File currentLogFile = await fileManager.getNewFile(baseDirectory + logPath + logFileName);
   await fileManager.writeFile(await currentLogFile.exists() ? '\nappednd'.codeUnits:'helloWorld'.codeUnits, filePath: currentLogFile.path,append: await currentLogFile.exists() ? true:false);
}