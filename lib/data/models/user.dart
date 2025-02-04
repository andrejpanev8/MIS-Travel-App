import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../enums/user_role.dart';

class User {
  int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String _passwordHash;
  UserRole role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required String password,
    required this.role,
  }) : _passwordHash = _hashPassword(password);

  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  bool verifyPassword(String password) {
    return _hashPassword(password) == _passwordHash;
  }

  User.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        phoneNumber = data['phoneNumber'],
        email = data['email'],
        _passwordHash = data['passwordHash'],
        role = UserRole.values.firstWhere(
            (e) => e.toString().split('.').last == data['role'],
            orElse: () => UserRole.CLIENT);

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'role': role.toString().split('.').last,
      };

  Map<String, dynamic> toJsonWithPassword() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'role': role.toString().split('.').last,
        'passwordHash': _passwordHash,
      };
}
