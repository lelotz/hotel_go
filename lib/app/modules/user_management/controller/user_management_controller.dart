import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/data/local_storage/sqlite_db_helper.dart';
import 'package:hotel_pms/app/data/models_n/admin_user_model.dart';
import 'package:hotel_pms/core/values/app_constants.dart';

import '../../../data/local_storage/repository/admin_user_repo.dart';

class UserManagementController extends GetxController{

  TextEditingController searchController = TextEditingController();
  Rx<List<AdminUser>> allEmployees = Rx<List<AdminUser>>([]);
  Rx<List<AdminUser>> receptionEmployees = Rx<List<AdminUser>>([]);
  Rx<List<AdminUser>> housekeepingEmployees = Rx<List<AdminUser>>([]);
  Rx<List<AdminUser>> adminEmployees = Rx<List<AdminUser>>([]);
  Rx<AdminUser> selectedUser = Rx<AdminUser>(AdminUser());

  @override
  void onReady() async{
    await getAllAdminUsers();
    super.onReady();
  }

  updateUI(){
    allEmployees.refresh();
    receptionEmployees.refresh();
    housekeepingEmployees.refresh();
    adminEmployees.refresh();
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
    sortEmployees();
    updateUI();

  }

  sortEmployees(){
    for(AdminUser employee in allEmployees.value){
      if(employee.position == AppConstants.userRoles[1]){
        adminEmployees.value.add(employee);
      }else if (employee.position == AppConstants.userRoles[300]){
        receptionEmployees.value.add(employee);
      }else if(employee.position ==  AppConstants.userRoles[600]){
        housekeepingEmployees.value.add(employee);
      }
    }
  }

}