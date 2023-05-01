

bool isAlphabeticOnly(String givenString,{String divider=' ',bool useDivider=false}){
  String workingString = givenString;
  bool result = false;
  if(useDivider){
    workingString = workingString.replaceAll(divider, "");
    if(RegExp(r'^[aA-zZ]').hasMatch(workingString)) result = true;
  }else{
    if(RegExp(r'^[aA-zZ]').hasMatch(workingString)) result = true;
  }
  return result;
}