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
}

