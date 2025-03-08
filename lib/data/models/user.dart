import '../enums/user_role.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  UserRole role;

  UserModel({
    this.id = "",
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.role,
  });

  UserModel.fromJson(Map<String, dynamic> data)
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

  UserModel copyWith(
      {String? id,
      String? firstName,
      String? lastName,
      String? phoneNumber,
      String? email,
      UserRole? role}) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$firstName $lastName $phoneNumber";
  }

  String get fullName {
    return "$firstName $lastName";
  }
}
