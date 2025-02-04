class Invitation {
  final String id;
  final DateTime expirationDate;
  final String email;
  bool isAccepted;

  Invitation({
    this.id = "",
    required this.expirationDate,
    required this.email,
    this.isAccepted = false,
  });

  Invitation.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        expirationDate = DateTime.parse(data['expirationDate']),
        email = data['email'],
        isAccepted = data['isAccepted'] ?? false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'expirationDate': expirationDate.toIso8601String(),
        'email': email,
        'isAccepted': isAccepted,
      };
}
