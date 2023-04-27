import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/session_management/session_manager.dart';


// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// Local import
import 'dart:io';
import 'package:get/get.dart';
import '../values/assets.dart';
import '../values/localization/local_keys.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/core/utils/utils.dart';
import 'package:logger/logger.dart';

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
          sheetData[sheetData.keys.first]?.currentState?.exportToExcelWorksheet(worksheet,defaultRowHeight: 26,exportRowHeight: false);

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
    sheet.getRangeByName('B8').setText(LocalKeys.kLaundry);
    sheet.getRangeByName('B9').setText(LocalKeys.kConference);
    sheet.getRangeByName('B10').setText('${LocalKeys.kConference} Advance');
    sheet.getRangeByName('B11').setText(LocalKeys.kRoomService);
    sheet.getRangeByName('B12').setText('${LocalKeys.kRooms} ${LocalKeys.kDebts}');
    sheet.getRangeByName('B13').setText(LocalKeys.kPettyCash);

    sheet.getRangeByName('B15').setText('TOTAL');
    sheet.getRangeByName('B15:C15').cellStyle.bold = true;
    sheet.getRangeByName('C15').cellStyle.numberFormat = '###,###,##0.00';
    sheet.getRangeByName('C15').setFormula('=SUM(C7:C11)');

    sheet.getRangeByName('C7').setNumber(excelData[LocalKeys.kRooms]);
    sheet.getRangeByName('C8').setNumber(excelData[LocalKeys.kLaundry]);

    sheet.getRangeByName('C9').setNumber(excelData[LocalKeys.kConference]);
    sheet.getRangeByName('C10').setNumber(excelData['${LocalKeys.kConference} Advance']);
    sheet.getRangeByName('C11').setNumber(excelData[LocalKeys.kRoomService]);
    sheet.getRangeByName('C12').setNumber(excelData['${LocalKeys.kRooms} ${LocalKeys.kDebts}']);
    sheet.getRangeByName('C12').cellStyle.fontColor = '#ff0000';
    sheet.getRangeByName('C13').setNumber(excelData[LocalKeys.kPettyCash]);
    sheet.getRangeByName('C13').cellStyle.fontColor = '#ff0000';
    sheet.getRangeByName('C7:C13').cellStyle.numberFormat = '###,###,##0.00';

    return workbook;
  }

  Worksheet setEmployeeDetailsBorder(Worksheet sheet){
    sheet.getRangeByName('C10:F10').cellStyle.borders.top.lineStyle = LineStyle.thin;
    sheet.getRangeByName('F10:F12').cellStyle.borders.right.lineStyle = LineStyle.thin;
    sheet.getRangeByName('C12:F12').cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    sheet.getRangeByName('C10:C12').cellStyle.borders.left.lineStyle = LineStyle.thin;
    return sheet;
  }

  Worksheet mergeRows(String rowStartA,int rowStartN,String rowEndA,int rowEndN,Worksheet sheet){
    int currentRow = rowStartN;
    while(currentRow <= rowEndN){
      sheet.getRangeByName('$rowStartA$currentRow:$rowEndA$currentRow').merge();

      currentRow++;
    }

    return sheet;
  }

  Workbook createReportSummaryTemplate(Map<String,dynamic> excelData,Map<String,dynamic> employeeDetails){
    Workbook workbook = Workbook();
    SessionManager sessionManager = Get.find<SessionManager>();

    Worksheet sheet = workbook.worksheets[0];
    sheet.enableSheetCalculations();
    sheet.name = 'Summary';
    sheet = setEmployeeDetailsBorder(sheet);
    sheet = mergeRows('D', 17, 'J', 34, sheet);
    
    Range wholeDocumentRange = sheet.getRangeByName('A1:L35');
    wholeDocumentRange.cellStyle.fontName = 'Arial';
    wholeDocumentRange.cellStyle.fontSize = 11;

    Range footerRange = sheet.getRangeByName('C1:L8');
    Range summaryTableRange = sheet.getRangeByName('C15:L34');
    Range summaryTableHeaderRange = sheet.getRangeByName('C15:L16');
    Range summaryTableColumnsRange = sheet.getRangeByName('C17:L17');
    Range summaryTableBodyRange = sheet.getRangeByName('C18:L34');
    Range summaryTableItemRange = sheet.getRangeByName('D18:D34');
    Range summaryTableCountRange = sheet.getRangeByName('C18:C34');
    Range summaryTableUnitRange = sheet.getRangeByName('J18:J34');
    Range summaryTableValueRange = sheet.getRangeByName('L18:L34');
    Range employeeDetailsRange = sheet.getRangeByName('C10:F13');


    footerRange.merge();
    summaryTableHeaderRange.merge();

    summaryTableColumnsRange.rowHeight = 24;
    summaryTableBodyRange.rowHeight = 19;
    summaryTableValueRange.columnWidth = 20;
    summaryTableUnitRange.columnWidth = 20;


    
    footerRange.cellStyle.vAlign = VAlignType.bottom;
    footerRange.cellStyle.hAlign = HAlignType.center;

    summaryTableHeaderRange.cellStyle.vAlign = VAlignType.center;
    summaryTableHeaderRange.cellStyle.hAlign = HAlignType.center;
    summaryTableItemRange.cellStyle.indent = 3;

    summaryTableRange.cellStyle.borders.all.lineStyle = LineStyle.thin;





    // Adding an image.
    final List<int> imageBytes = File(Assets.kLogo).readAsBytesSync();
    sheet.pictures.addStream(2, 7, imageBytes);
    Picture picture = sheet.pictures[0];
    // Re-size an image
    picture.height = 100;
    picture.width = 100;


    sheet.getRangeByName('C10').columnWidth = 9.0;
    sheet.getRangeByName('D10').columnWidth = 9.0;
    footerRange.setText('WHITEMARK HOTELS REPORT');
    sheet.getRangeByName('C9:L9').merge();
    sheet.getRangeByName('C10:D10').merge();
    sheet.getRangeByName('C10:D10').setText('EMPLOYEE');
    sheet.getRangeByName('E10:F10').merge();
    sheet.getRangeByName('E10:F10').columnWidth = 18.0;
    sheet.getRangeByName('E10:F10').setText(employeeDetails['name']);

    sheet.getRangeByName('C11:D11').merge();
    sheet.getRangeByName('C10').rowHeight = 23;
    sheet.getRangeByName('E11').rowHeight = 23;
    sheet.getRangeByName('E12').rowHeight = 23;
    sheet.getRangeByName('C11:D11').setText('Dates');

    sheet.getRangeByName('E11').setText(extractDate(DateTime.parse(employeeDetails['start'])));
    sheet.getRangeByName('F11').setText(extractDate(DateTime.parse(employeeDetails['end'])));
    sheet.getRangeByName('E12').setText(extractTime(DateTime.parse(employeeDetails['start'])));
    sheet.getRangeByName('F12').setText(extractTime(DateTime.parse(employeeDetails['end'])));


    summaryTableHeaderRange.setText('SUMMARY');
    sheet.getRangeByName('C17').setText('S/N');
    sheet.getRangeByName('D17:J17').setText('Item');
    sheet.getRangeByName('K17').setText('Unit');
    sheet.getRangeByName('L17').setText('Value');

    /// Rooms
    sheet.getRangeByName('C18').setNumber(1);
    sheet.getRangeByName('D18:J18').setText('   ' + LocalKeys.kRooms);
    sheet.getRangeByName('K18').setNumber(excelData[LocalKeys.kRooms+'Count']);
    sheet.getRangeByName('L18').setNumber(excelData[LocalKeys.kRooms]);

    /// Rooms Debts
    sheet.getRangeByName('C19').setNumber(2);
    sheet.getRangeByName('D19:J19').setText('${LocalKeys.kRooms} ${LocalKeys.kDebts}');
    sheet.getRangeByName('K19').setText('0');
    sheet.getRangeByName('L19').setNumber(excelData['${LocalKeys.kRooms} ${LocalKeys.kDebts}']);


    /// Conference
    sheet.getRangeByName('C21').setNumber(4);
    sheet.getRangeByName('D21:J21').setText('   ' + LocalKeys.kConference);
    sheet.getRangeByName('K21').setText('');
    sheet.getRangeByName('L21').setNumber(excelData[LocalKeys.kConference]);

    /// Conference Advance
    sheet.getRangeByName('C20').setNumber(3);
    sheet.getRangeByName('D20:J20').setText('   ${LocalKeys.kConference} Advance');
    sheet.getRangeByName('K20').setText('');
    sheet.getRangeByName('L20').setNumber(excelData['${LocalKeys.kConference} Advance']);

    /// Laundry
    sheet.getRangeByName('C22').setNumber(5);
    sheet.getRangeByName('D22:J22').setText('   ' + LocalKeys.kLaundry);
    sheet.getRangeByName('K22').setText('');
    sheet.getRangeByName('L22').setNumber(excelData[LocalKeys.kLaundry]);

    /// Room Service
    sheet.getRangeByName('C23').setNumber(6);
    sheet.getRangeByName('D23:J23').setText('   ' + LocalKeys.kRoomService);
    sheet.getRangeByName('K23').setText('');
    sheet.getRangeByName('L23').setNumber(excelData[LocalKeys.kRoomService]);


    /// Laundry
    sheet.getRangeByName('C24').setNumber(7);
    sheet.getRangeByName('D24:J24').setText('   ' + LocalKeys.kLaundry);
    sheet.getRangeByName('K24').setText('');
    sheet.getRangeByName('L24').setNumber(excelData[LocalKeys.kLaundry]);

    /// Petty Cash
    sheet.getRangeByName('C25').setNumber(8);
    sheet.getRangeByName('D25:J25').setText('   ' + LocalKeys.kPettyCash);
    sheet.getRangeByName('K25').setText('');
    sheet.getRangeByName('L25').setNumber(excelData[LocalKeys.kPettyCash]);









    // sheet.getRangeByName('B6:C6').cellStyle.bold = true;
    // //sheet.getRangeByName('B6:C6').columnWidth = 20;
    // sheet.getRangeByName('B6').setText('ITEM');
    // sheet.getRangeByName('C6').setText('COLLECTED PAYMENT');
    //
    // sheet.getRangeByName('B7').setText(LocalKeys.kRooms);
    // sheet.getRangeByName('B8').setText(LocalKeys.kLaundry);
    // sheet.getRangeByName('B9').setText(LocalKeys.kConference);
    // sheet.getRangeByName('B10').setText('${LocalKeys.kConference} Advance');
    // sheet.getRangeByName('B11').setText(LocalKeys.kRoomService);
    // sheet.getRangeByName('B12').setText('${LocalKeys.kRooms} ${LocalKeys.kDebts}');
    // sheet.getRangeByName('B13').setText(LocalKeys.kPettyCash);
    //
    // sheet.getRangeByName('B15').setText('TOTAL');
    // sheet.getRangeByName('B15:C15').cellStyle.bold = true;
    // sheet.getRangeByName('C15').cellStyle.numberFormat = '###,###,##0.00';
    // sheet.getRangeByName('C15').setFormula('=SUM(C7:C11)');
    //
    // sheet.getRangeByName('C7').setNumber(excelData[LocalKeys.kRooms]);
    // sheet.getRangeByName('C8').setNumber(excelData[LocalKeys.kLaundry]);
    //
    // sheet.getRangeByName('C9').setNumber(excelData[LocalKeys.kConference]);
    // sheet.getRangeByName('C10').setNumber(excelData['${LocalKeys.kConference} Advance']);
    // sheet.getRangeByName('C11').setNumber(excelData[LocalKeys.kRoomService]);
    // sheet.getRangeByName('C12').setNumber(excelData['${LocalKeys.kRooms} ${LocalKeys.kDebts}']);
    // sheet.getRangeByName('C12').cellStyle.fontColor = '#ff0000';
    // sheet.getRangeByName('C13').setNumber(excelData[LocalKeys.kPettyCash]);
    // sheet.getRangeByName('C13').cellStyle.fontColor = '#ff0000';
    // sheet.getRangeByName('C7:C13').cellStyle.numberFormat = '###,###,##0.00';

    return workbook;
  }

  Workbook buildDailyReportTemplate(Map<String,dynamic> excelData){
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
    sheet.getRangeByName('B8').setText(LocalKeys.kLaundry);
    sheet.getRangeByName('B9').setText(LocalKeys.kConference);
    sheet.getRangeByName('B10').setText('${LocalKeys.kConference} Advance');
    sheet.getRangeByName('B11').setText(LocalKeys.kRoomService);
    sheet.getRangeByName('B12').setText('${LocalKeys.kRooms} ${LocalKeys.kDebts}');
    sheet.getRangeByName('B13').setText(LocalKeys.kPettyCash);

    sheet.getRangeByName('B15').setText('TOTAL');
    sheet.getRangeByName('B15:C15').cellStyle.bold = true;
    sheet.getRangeByName('C15').cellStyle.numberFormat = '###,###,##0.00';
    sheet.getRangeByName('C15').setFormula('=SUM(C7:C11)');

    sheet.getRangeByName('C7').setNumber(excelData[LocalKeys.kRooms]);
    sheet.getRangeByName('C8').setNumber(excelData[LocalKeys.kLaundry]);

    sheet.getRangeByName('C9').setNumber(excelData[LocalKeys.kConference]);
    sheet.getRangeByName('C10').setNumber(excelData['${LocalKeys.kConference} Advance']);
    sheet.getRangeByName('C11').setNumber(excelData[LocalKeys.kRoomService]);
    sheet.getRangeByName('C12').setNumber(excelData['${LocalKeys.kRooms} ${LocalKeys.kDebts}']);
    sheet.getRangeByName('C12').cellStyle.fontColor = '#ff0000';
    sheet.getRangeByName('C13').setNumber(excelData[LocalKeys.kPettyCash]);
    sheet.getRangeByName('C13').cellStyle.fontColor = '#ff0000';
    sheet.getRangeByName('C7:C13').cellStyle.numberFormat = '###,###,##0.00';

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
