
import 'package:hotel_pms/core/logs/logger_instance.dart';
import 'package:logger/logger.dart';

class ConferenceCalculator{
  Logger logger = AppLogger.instance.logger;

  static int calculatePriceForPackage(int packagePrice,{required int peopleCount,required int days}){
    print('(packagePrice * peopleCount) * days${(packagePrice * peopleCount) * days}');
    return (packagePrice * peopleCount) * days;
  }

  static int calculatePriceForDaily(int dayCost,int days){
    return dayCost * days;
  }

  static int calculatePriceForHourly(int hourlyPrice,{required int hours}){
    return hourlyPrice * hours;
  }
  static int calculatePriceForRestaurant(int packagePrice,{required int days}){
    return packagePrice * days;
  }



}