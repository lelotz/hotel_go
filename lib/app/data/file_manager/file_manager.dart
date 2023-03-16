import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/logs/logger_instance.dart';


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
    try{
      // defining directory for file
      directory = await getApplicationDocumentsDirectory();
    }catch(e){
      logger.e({'Documents Director Error'},e);
    }


    return directory;

  }

  // defining path for jsonFile
  Future<File> get _jsonFile async{
    const path = "E:/Projects/tbd_company_name_projects/Whitemark Hotels/HotelPMS/hotel_pms/lib/mock_data";


    return File('$path/names.json');
  }

  createFolder(String path)async{

    Directory? dir  = await directoryPath;
    Directory directory = Directory('${dir!.path}\\$defaultStoragePath\\$path');
    try{
      if(dir.path.isNotEmpty) {
        directory.create();
      } else {}
    }catch(e){
      logger.e(e);
    }

  }

  Future<File> writeFile(List<int> bytes,{required String filePath,FileMode fileMode = FileMode.write})async{
    File file = File(filePath);
    try{
      file = await file.writeAsBytes(bytes, flush: true,mode: FileMode.write);
    }on PathNotFoundException catch(e) {
      logger.e({'':'writeFile','pathNotFound': filePath}, e);
    }catch (otherError){
      logger.e({'':'writeFile','otherErrors': filePath}, otherError);
    }
    return file;
  }




  Future<Map<String, dynamic>> readJsonFile() async {
    String? fileContent;

    // Creating a file
    File file = await _jsonFile;

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

  dynamic writeJsonFile(dynamic gate) async {
    File file = await _jsonFile;
    await file.writeAsString(json.encode(gate));
    return gate;
  }

}