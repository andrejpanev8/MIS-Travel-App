import 'package:intl/intl.dart';

class Invitation {
  final String id;
  final String uniqueCode;
  final DateTime expirationDate;
  final String email;
  bool isAccepted;

  Invitation({
    this.id = "",
    required this.uniqueCode,
    required this.expirationDate,
    required this.email,
    this.isAccepted = false,
  });

  Invitation.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        uniqueCode = data['uniqueCode'],
        expirationDate = DateTime.parse(data['expirationDate']),
        email = data['email'],
        isAccepted = data['isAccepted'] ?? false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uniqueCode': uniqueCode,
        'expirationDate': expirationDate.toIso8601String(),
        'email': email,
        'isAccepted': isAccepted,
      };

  String getStatus() {
    if (isAccepted) {
      return "Accepted";
    } else if (expirationDate.isAfter(DateTime.now())) {
      return "Pending";
    } else {
      return "Expired";
    }
  }

  String getFormattedExpirationDate() {
    return DateFormat('dd.MM.yyyy - HH:mm').format(expirationDate);
  }
}
