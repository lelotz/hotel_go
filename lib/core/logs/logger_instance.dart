import 'package:logger/logger.dart';

class AppLogger{
  AppLogger._privateConstruct();
  static final AppLogger instance = AppLogger._privateConstruct();

  Logger get logger => Logger(printer: PrettyPrinter(methodCount: 0));


}