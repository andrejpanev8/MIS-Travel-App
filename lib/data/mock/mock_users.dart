import '../models/user.dart';
import '../enums/user_role.dart';

final List<UserModel> mockUsers = [
  UserModel(
    id: '1',
    firstName: 'Alice',
    lastName: 'Smith',
    phoneNumber: '+1234567890',
    email: 'alice.smith@example.com',
    role: UserRole.ADMIN,
  ),
  UserModel(
    id: '2',
    firstName: 'Bob',
    lastName: 'Johnson',
    phoneNumber: '+1987654321',
    email: 'bob.johnson@example.com',
    role: UserRole.CLIENT,
  ),
  UserModel(
    id: '3',
    firstName: 'Charlie',
    lastName: 'Brown',
    phoneNumber: '+1122334455',
    email: 'charlie.brown@example.com',
    role: UserRole.DRIVER,
  ),
  UserModel(
    id: '4',
    firstName: 'Diana',
    lastName: 'Williams',
    phoneNumber: '+1555666777',
    email: 'diana.williams@example.com',
    role: UserRole.CLIENT,
  ),
  UserModel(
    id: '5',
    firstName: 'Ethan',
    lastName: 'Davis',
    phoneNumber: '+1444555666',
    email: 'ethan.davis@example.com',
    role: UserRole.CLIENT,
  ),
];
