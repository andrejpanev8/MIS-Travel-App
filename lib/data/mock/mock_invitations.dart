import 'package:travel_app/data/models/invitation.dart';

final List<Invitation> mockInvitations = [
  Invitation(
    id: "inv1",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "john.doe@example.com",
    isAccepted: false,
  ),
  Invitation(
    id: "inv2",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "jane.smith@example.com",
    isAccepted: true,
  ),
  Invitation(
    id: "inv3",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "alice.jones@example.com",
    isAccepted: false,
  ),
  Invitation(
    id: "inv4",
    expirationDate: DateTime.now().add(Duration(days: 1)),
    email: "bob.brown@example.com",
    isAccepted: true,
  ),
];
