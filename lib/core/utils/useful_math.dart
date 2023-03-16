

import 'dart:math';

class GlobalCalculations {
  //GlobalCalculations();

  int calculateRoomCost(int roomNumber, int nights){
    if(roomNumber >= 200) return nights * 35000;
    return nights * 30000;
  }
}

Map<String,dynamic> minAndMaxIntInList(List<int> intList){
  var largestValue = intList[0];
  var smallestValue = intList[0];

  for (var i = 0; i < intList.length; i++) {

    // Checking for largest value in the list
    if (intList[i] > largestValue) {
      largestValue = intList[i];
    }

    // Checking for smallest value in the list
    if (intList[i] < smallestValue) {
      smallestValue = intList[i];
    }
  }


  return {'min': smallestValue,'max': largestValue};

}

int random(int min,int max){
  return min + Random().nextInt(max);
}
