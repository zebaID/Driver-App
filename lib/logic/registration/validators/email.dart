import 'package:formz/formz.dart';

enum EmailValidatorError { invalid }

class Email extends FormzInput<String, EmailValidatorError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidatorError? validator(String? value) {
    final regexp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

// find the first match though you could also do `allMatches`
    final match = regexp.hasMatch(value!);
    if (match) {
      return null;
    } else {
      EmailValidatorError.invalid;
    }
    // return value?.isNotEmpty == true ? null : MobileNumberValidationError.empty;
  }
}
