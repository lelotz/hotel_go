import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/login_screen/controller/auth_controller.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/values/localization/messages.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/values/assets.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  
  final signInFormKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController(isTest: false), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorsManager.whiteGradients,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(Assets.kLoginBackground)),
        ),
        child: Center(
          /// Login Form
          child: Container(
            width: const Size.fromWidth(280).width,
            height: const Size.fromHeight(420).height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: ColorsManager.primary,
                    offset: Offset(0.0, 3.0),
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                    color: Color(0x24000000),
                    offset: Offset(0.0, 2.0),
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                    color: Color(0x1f000000),
                    offset: Offset(0.0, 1.0),
                    blurStyle: BlurStyle.normal)
              ],
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Logo
                Container(
                  height: 100,
                  width: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.kLogo),
                        // fit: BoxFit
                      )),
                ),
                
                ReactiveFormBuilder(
                    form: ()=>authController.getLoginForm(),
                    builder: (context,form,child){
                        return Column(
                          children: [
                            ReactiveTextField<String>(
                              formControlName: 'username',
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                AppMessages.isNotEmpty.tr,
                              },

                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                helperText: '',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ReactiveTextField<String>(
                              formControlName: 'password',
                              obscureText: true,
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                AppMessages.isNotEmpty.tr,
                              },
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                helperText: '',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async{
                                if (form.valid) {
                                  await authController.loginUser();
                                } else {
                                  form.markAllAsTouched();
                                }
                              },
                              child: const Text('Sign Up'),
                            ),
                            ElevatedButton(
                              onPressed: () => form.resetState({
                                'username': ControlState<String>(value: null),
                                'password': ControlState<String>(value: null),

                              }, removeFocus: true),
                              child: const Text('Reset all'),
                            ),
                          ],
                        );
                    }),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
