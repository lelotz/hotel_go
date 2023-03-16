import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/local_storage/table_keys.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';

import '../../../data/local_storage/repository/admin_user_repo.dart';

class UserManagementController extends GetxController{

  TextEditingController searchController = TextEditingController();
  Rx<List<AdminUser>> allEmployees = Rx<List<AdminUser>>([]);

  @override
  void onReady() async{
    await getAllAdminUsers();
    super.onReady();
  }

  updateUI(){
    allEmployees.refresh();
  }

  Future<void> getAllAdminUsers()async{
    allEmployees.value.clear();

    await SqlDatabase.instance.read(tableName: AdminUsersTable.tableName,readAll: true).then((value){
      if(value!=null){
        for(Map<String,dynamic> user in value){
          allEmployees.value.add(AdminUser.fromJson(user));
        }
      }
    });

    updateUI();

  }

}