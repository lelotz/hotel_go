import 'package:logger/logger.dart';

class AppLogger{
  AppLogger._privateConstruct();
  static final AppLogger instance = AppLogger._privateConstruct();
  //LogFilter logFilter = LogFilter()

  Logger get logger => Logger(
      printer: PrettyPrinter(methodCount: 0),
      //level: Level.warning
  );


}