import '../enums/user_role.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  UserRole role;

  User({
    this.id = "",
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.role,
  }) ;

  User.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        phoneNumber = data['phoneNumber'],
        email = data['email'],
        role = UserRole.values[data['role'] ?? 0];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'role': role.index
      };

}
