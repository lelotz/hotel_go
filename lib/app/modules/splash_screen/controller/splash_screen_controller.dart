
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';

class SplashScreenController extends GetxController{
  Rx<bool> isInitialized = false.obs;
  Rx<bool> appDirectoryFound = false.obs;
  Rx<String> appDirectory = ''.obs;
  FileManager fileManager = FileManager();

  @override
  Future<void> onReady() async{
    await validateAppDirectory();
    super.onReady();
  }

  Future<void> validateAppDirectory()async{
    appDirectory.value = await fileManager.directoryPath.then((value) => value == null ? '' : value.path);
    isInitialized.value = true;
    if(appDirectory.value != '') appDirectoryFound.value = true;

    if(appDirectoryFound.value){
      Future.delayed(const Duration(seconds: 2), (){Get.to(()=>LandingPage());});

    }
  }

}