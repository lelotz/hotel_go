
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/file_manager/file_manager.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/app/modules/user_data/controller/user_data_controller.dart';

class SplashScreenController extends GetxController{
  Rx<bool> isInitialized = false.obs;
  Rx<bool> appDirectoryFound = false.obs;
  Rx<String> appDirectory = ''.obs;
  FileManager fileManager = FileManager();
  UserData userData = Get.put(UserData(),permanent: true);
  Rx<String> appExecutablePath = Rx<String>('');


  @override
  Future<void> onReady() async{
    await userData.onInit();
    await validateAppDirectory();
    appExecutablePath.value = await fileManager.executableDirectory;
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