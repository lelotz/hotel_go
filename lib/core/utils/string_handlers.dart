
int stringToInt(String? givenString){
  int result = 0;
  try{
    result = int.parse(givenString!);
  }catch(e){
    print(e.toString());
  }
  return result;
}