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
      RequiredValidator(errorText: "Enter first name"),
      MinLengthValidator(3, errorText: "First name must be more than 4 letters")
    ])(value);
  }

  static String? surnameValidator(String? value) {
    return MultiValidator([
      RequiredValidator(errorText: "Enter last name"),
      MinLengthValidator(3, errorText: "Last name must be more than 4 letters")
    ])(value);
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    }

    if (value.startsWith('07') && value.length == 9) {
      return null;
    }

    if (value.startsWith('+3897') && value.length == 12) {
      return null;
    }

    return 'Valid format: 07X XXX XXX or +389 7X XXX XXX';
  }

  static List<String> passwordValidator(String? value) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      errors.add('Password is required');
    } else {
      if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
        errors.add('Password must contain at least one lowercase letter');
      }

      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
        errors.add('Password must contain at least one uppercase letter');
      }

      if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
        errors.add('Password must contain at least one number');
      }

      if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
        errors.add('Password must contain at least one special character');
      }

      if (value.length < 8) {
        errors.add('Password must be at least 8 characters long');
      }
    }

    return errors;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? requiredValidator(String? value, {required String field}) {
    return RequiredValidator(errorText: "Required $field! ")(value);
  }

  static String? maxLengthValidator(String? value, {required int maxLength}) {
    return MaxLengthValidator(maxLength,
        errorText:
            "Message can't be longer than $maxLength characters!")(value);
  }

  static String? uniqueCodeValidator(String value) {
    final regex = RegExp(r'^[a-zA-Z]{6}$');
    if (value.isEmpty) {
      return 'Invitation code cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid invitation code';
    }
    return null;
  }
}
