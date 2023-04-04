import 'package:flutter/material.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:logger/logger.dart';

// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// Local import
import 'dart:io';

//import 'package:open_file/open_file.dart' as open_file;
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import '../values/localization/local_keys.dart';
int getMaxTableRows(int maxRows) {
  if (maxRows > 8) return 8;
  if (maxRows == 0) return 1;
  return maxRows;
}

double getDataRowHeight(int length) {
  return length * .30;
}

class ExcelWorkBook{
  ExcelWorkBook({required this.sheetProperties,required this.excelFileName});

  List<Map<String,GlobalKey<SfDataGridState>>> sheetProperties;
  String excelFileName;
  Logger logger = AppLogger.instance.logger;

  Future<Directory?> get storageDirectory async {
    return await FileManager().directoryPath;
  }

  createFileWithSheetsFromSfTable(String filePath,Workbook workbook, {bool launchFile=false})async{

    logger.i({'creating workbook': sheetProperties.length});
    int sheetIndex = 0;


    for(Map<String,GlobalKey<SfDataGridState>> sheetData in sheetProperties){
      if(sheetData[sheetData.keys.first] != null && sheetData[sheetData.keys.first]!.currentState !=null){
        try{
          Worksheet worksheet = workbook.worksheets.addWithName(sheetData.keys.first);
          sheetData[sheetData.keys.first]?.currentState?.exportToExcelWorksheet(worksheet);
          sheetIndex++;
        }catch (e){
          logger.e({'error_sheet':e.toString(),'sheetName':sheetData.keys.first});
        }

      }else{
        logger.i({'sheetNameEmpty':sheetData[sheetData.keys.first]});
      }
    }

    logger.i({'workbook created': workbook.worksheets.count});
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, '$filePath.xlsx',launchFile: launchFile);
    showSnackBar('Created ${sheetIndex + 1} sheets', Get.context!);
  }

  Workbook createDailyReportSummary(Map<String,dynamic> excelData){
    Workbook workbook = Workbook();

    Worksheet sheet = workbook.worksheets[0];
    sheet.enableSheetCalculations();
    sheet.name = 'Summary';
    sheet.getRangeByName('B1:D3').merge();
    sheet.getRangeByName('B1:D3').cellStyle.fontSize = 16;
    sheet.getRangeByName('B1:D3').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('B1:D3').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('B1:D3').setText('${extractDate(DateTime.now())} Report Summary');

    sheet.getRangeByName('B6:C6').cellStyle.bold = true;
    sheet.getRangeByName('B6:C6').columnWidth = 20;
    sheet.getRangeByName('B6').setText('ITEM');
    sheet.getRangeByName('C6').setText('COLLECTED PAYMENT');

    sheet.getRangeByName('B7').setText(LocalKeys.kRooms);
    sheet.getRangeByName('B8').setText('${LocalKeys.kRooms} ${LocalKeys.kDebts}');
    sheet.getRangeByName('B9').setText(LocalKeys.kConference);
    sheet.getRangeByName('B10').setText('${LocalKeys.kConference} Advance');
    sheet.getRangeByName('B11').setText(LocalKeys.kRoomService);
    sheet.getRangeByName('B12').setText(LocalKeys.kLaundry);

    sheet.getRangeByName('B14').setText('TOTAL');
    sheet.getRangeByName('B14:C14').cellStyle.bold = true;
    sheet.getRangeByName('C14').cellStyle.numberFormat = '###,###,##0.00';
    sheet.getRangeByName('C14').setFormula('=SUM(C7:C12)');

    sheet.getRangeByName('C7').setNumber(excelData[LocalKeys.kRooms]);
    sheet.getRangeByName('C8').setNumber(excelData['${LocalKeys.kRooms} ${LocalKeys.kDebts}']);
    sheet.getRangeByName('C9').setNumber(excelData[LocalKeys.kConference]);
    sheet.getRangeByName('C10').setNumber(excelData['${LocalKeys.kConference} Advance']);
    sheet.getRangeByName('C11').setNumber(excelData[LocalKeys.kRoomService]);
    sheet.getRangeByName('C12').setNumber(excelData[LocalKeys.kLaundry]);
    sheet.getRangeByName('C7:C12').cellStyle.numberFormat = '###,###,##0.00';

    return workbook;
  }



  Future<String> getPath() async {
    Directory? directory = await storageDirectory;

    if (directory != null) return directory.path;
    return '';
  }



  Future<void> exportDataGridToExcel(
      {required GlobalKey<SfDataGridState> key,
        required String filePath,
        String fileCategory = 'Reports',bool launchFile=true}) async {
    final Workbook workbook = key.currentState!.exportToExcelWorkbook();


    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, '$filePath.xlsx',launchFile: launchFile);
  }

  Future<void> exportDataGridToPdf(
      {required GlobalKey<SfDataGridState> key,
        required String filePath,
        String fileCategory = 'Reports'}) async {
    final PdfDocument document =
    key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = document.saveSync();
    await saveAndLaunchFile(bytes, "$filePath.pdf");
    document.dispose();
  }

  //String reportsPath = "C:\\Users\\Dereck\\Documents\\Hotels_Go\\Reports\\";
  ///To save the Excel file in the Mobile and Desktop platforms.
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName,
      {bool launchFile = true}) async {
    String? path = await getPath();

    final String fileLocation =
    Platform.isWindows ? "$path$fileName" : '$path/$fileName';
    await FileManager().writeFile(bytes, filePath: fileLocation);

    if (launchFile) {
      if (Platform.isAndroid || Platform.isIOS) {
        //await open_file.OpenFile.open(fileLocation);
      } else if (Platform.isWindows) {
        // print(fileLocation);
        await Process.run('start', <String>[fileLocation], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', <String>[fileLocation], runInShell: true);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
      }
    }
  }
}


class ExportTableData {
  ExportTableData();

  Future<Directory?> get storageDirectory async {
    return await FileManager().directoryPath;
  }

  Future<String> getPath() async {
    Directory? directory = await storageDirectory;

    if (directory != null) return directory.path;
    return '';
  }

  Future<void> exportDataGridToExcel(
      {required GlobalKey<SfDataGridState> key,
      required String filePath,
      String fileCategory = 'Reports',bool launchFile=true}) async {
    final Workbook workbook = key.currentState!.exportToExcelWorkbook();
    workbook.worksheets.add();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, '$filePath.xlsx',launchFile: launchFile);
  }

  Future<void> exportDataGridToPdf(
      {required GlobalKey<SfDataGridState> key,
      required String filePath,
      String fileCategory = 'Reports'}) async {
    final PdfDocument document =
        key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = document.saveSync();
    await saveAndLaunchFile(bytes, "$filePath.pdf");
    document.dispose();
  }

  //String reportsPath = "C:\\Users\\Dereck\\Documents\\Hotels_Go\\Reports\\";
  ///To save the Excel file in the Mobile and Desktop platforms.
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName,
      {bool launchFile = true}) async {
    String? path = await getPath();
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
    await FileManager().writeFile(bytes, filePath: fileLocation);

    if (launchFile) {
      if (Platform.isAndroid || Platform.isIOS) {
        //await open_file.OpenFile.open(fileLocation);
      } else if (Platform.isWindows) {
        // print(fileLocation);
        await Process.run('start', <String>[fileLocation], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', <String>[fileLocation], runInShell: true);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
      }
    }
  }
}
