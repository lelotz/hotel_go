
import 'package:reactive_forms/reactive_forms.dart';

class PasswordAsyncValidator extends AsyncValidator<dynamic>{
  Function(String) passwordValidatorCallback;

  PasswordAsyncValidator(this.passwordValidatorCallback);
  @override
  Future<Map<String, dynamic>?> validate(AbstractControl<dynamic> control) async {
    final error = {'password imekosewa': false};

    final userExists = await _getDoesExistUser(control.value.toString());
    if (!userExists) {
      control.markAsTouched();
      return error;
    }

    return null;
  }

  /// Simulates a time consuming operation (i.e. a Server request)
  Future<bool> _getDoesExistUser(String password) async{
    return await passwordValidatorCallback(password);
  }
}