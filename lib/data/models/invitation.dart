import 'package:travel_app/data/models/user.dart';

import '../enums/user_role.dart';

class Invitation {
  int id;
  DateTime expirationDate;
  User user;
  bool isAccepted;

  Invitation({
    required this.id,
    required this.expirationDate,
    required this.user,
    this.isAccepted = false,
  });

  Invitation.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        expirationDate = DateTime.parse(data['expirationDate']),
        user = User.fromJson(data['user']),
        isAccepted = data['isAccepted'] ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'expirationDate': expirationDate.toIso8601String(),
    'user': user.toJson(),
    'isAccepted': isAccepted,
  };

  void accept() {
    if (isAccepted) {
      throw Exception("Invitation already accepted.");
    }
    if (DateTime.now().isAfter(expirationDate)) {
      throw Exception("Invitation has expired.");
    }

    isAccepted = true;
    user.role = UserRole.DRIVER;
  }
}
