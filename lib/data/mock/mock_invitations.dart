import 'package:travel_app/data/models/invitation.dart';

final List<Invitation> mockInvitations = [
  Invitation(
    id: "inv1",
    uniqueCode: "aGrThw",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "john.doe@example.com",
    isAccepted: false,
  ),
  Invitation(
    id: "inv2",
    uniqueCode: "srTTqT",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "jane.smith@example.com",
    isAccepted: true,
  ),
  Invitation(
    id: "inv3",
    uniqueCode: "xnWaeI",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "alice.jones@example.com",
    isAccepted: false,
  ),
  Invitation(
    id: "inv4",
    uniqueCode: "sRqvUU",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "bob.brown@example.com",
    isAccepted: true,
  ),
];
