import 'package:form_field_validator/form_field_validator.dart';

class ValidationUtils {
  static bool isValidName(String name) {
    final nameRegExp = RegExp(r'^[A-Za-z]+$');
    return nameRegExp.hasMatch(name);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(r'^\+?\d{9,15}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  static bool isValidEmail(String email) {
    return email.contains('@');
  }

  static String? nameValidator(String? value) {
    return MultiValidator([
      RequiredValidator(errorText: "Enter full name"),
      MinLengthValidator(4, errorText: "Full name must be more than 4 letters")
    ])(value);
  }

  static String? phoneValidator(String? value) {
    // Define the regular expression for the required format
    final regex = RegExp(r'^7\d{7}$'); // Only for screen drawing

    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    }
    if (!regex.hasMatch(value)) {
      return 'Valid format 7X XXX XXX';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    return EmailValidator(errorText: "Enter a correct e-mail address")(value);
  }

  static String? requiredValidator(String? value, {required String field}) {
    return RequiredValidator(errorText: "Required $field! ")(value);
  }

  static String? maxLengthValidator(String? value, {required int maxLength}) {
    return MaxLengthValidator(maxLength,
        errorText:
            "Message can't be longer than $maxLength characters!")(value);
  }
}
