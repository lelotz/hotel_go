import 'package:reactive_forms/reactive_forms.dart';

/// Validator that validates the user's email is unique, sending a request to
/// the Server.
class UserNameAsyncValidator extends AsyncValidator<dynamic> {

  Function(String) userNameValidatorCallback;

  UserNameAsyncValidator(this.userNameValidatorCallback);

  @override
  Future<Map<String, dynamic>?> validate(AbstractControl<dynamic> control) async {
    final error = {'Account yenye jina ${control.value.toString()} haipo': false};

    final userExists = await _getDoesExistUser(control.value.toString());
    if (!userExists) {
      control.markAsTouched();
      return error;
    }

    return null;
  }

  /// Simulates a time consuming operation (i.e. a Server request)
  Future<bool> _getDoesExistUser(String userName) async{
    return await userNameValidatorCallback(userName);
  }
}