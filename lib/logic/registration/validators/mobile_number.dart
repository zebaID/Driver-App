import 'package:formz/formz.dart';

enum MobileNumberValidationError { empty, invalid }

class MobileNumber extends FormzInput<String, MobileNumberValidationError> {
  const MobileNumber.pure() : super.pure('');
  const MobileNumber.dirty([String value = '']) : super.dirty(value);

  @override
  MobileNumberValidationError? validator(String? value) {
    final regexp = RegExp(r'^[+]*[(]{0,1}[6-9][+]{0,9}[0-9]*$');

// find the first match though you could also do `allMatches`
    final match = regexp.hasMatch(value!);
    if (match) {
      return null;
    } else {
      MobileNumberValidationError.empty;
    }
    // return value?.isNotEmpty == true ? null : MobileNumberValidationError.empty;
  }
}
