import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';

// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// Local import
import 'dart:io';

//import 'package:open_file/open_file.dart' as open_file;
// ignore: depend_on_referenced_packages



int getMaxTableRows(int maxRows){
  if(maxRows > 8) return 8;
  if(maxRows == 0) return 1;
  return maxRows;
}

double getDataRowHeight(int length){
  return length * .30;
}

class ExportTableData{

  ExportTableData();


  Future<Directory?> get storageDirectory async{
    return await FileManager().directoryPath;
  }

  Future<String> getPath()async{
    Directory? directory = await storageDirectory;

    if(directory != null) return directory.path;
    return '';
  }

  Future<void> exportDataGridToExcel({required GlobalKey<SfDataGridState> key,required String filePath,String fileCategory='Reports'}) async {

    final Workbook workbook = key.currentState!.exportToExcelWorkbook();



    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, '$filePath.xlsx');


  }

  Future<void> exportDataGridToPdf({required GlobalKey<SfDataGridState> key,required String filePath,String fileCategory='Reports'}) async {
    final PdfDocument document = key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = document.saveSync();
    await saveAndLaunchFile(bytes, "$filePath.pdf");
    document.dispose();
  }
  //String reportsPath = "C:\\Users\\Dereck\\Documents\\Hotels_Go\\Reports\\";
  ///To save the Excel file in the Mobile and Desktop platforms.
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    String? path =  await getPath();
    // if (Platform.isAndroid ||
    //     Platform.isIOS ||
    //     Platform.isLinux ||
    //     Platform.isWindows) {
    //   final Directory directory =
    //   await path_provider.getApplicationSupportDirectory();
    //   path = directory.path;
    // } else {
    //   path = await path_provider_interface.PathProviderPlatform.instance
    //       .getApplicationSupportPath();
    // }



    //Path.combine(PathOperation.union, path, fileName);
    final String fileLocation =
    Platform.isWindows ? "$path$fileName" : '$path/$fileName';
    FileManager().writeFile(bytes, filePath: fileLocation);

    if (Platform.isAndroid || Platform.isIOS) {
      //await open_file.OpenFile.open(fileLocation);
    } else if (Platform.isWindows) {
      print(fileLocation);
      await Process.run('start', <String>[fileLocation], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[fileLocation], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
    }
  }

}

