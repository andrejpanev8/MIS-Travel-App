import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/invitation.dart';
import 'package:travel_app/service/auth_service.dart';
import 'package:travel_app/service/user_service.dart';

import '../utils/functions.dart';
import '../data/models/user.dart';

class InvitationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();
  UserService userService = UserService();

  Future<String?> createInvitation({required String email}) async {
    UserModel? user = await authService.getCurrentUser();
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    if (user.role != UserRole.ADMIN) {
      throw Exception("You do not have a permission to create invitation");
    }

    DocumentReference invitationRef =
        _firestore.collection('invitations').doc();

    String invitationId = invitationRef.id;

    String uniqueCode = Functions.generateUniqueCode();
    Invitation invitation = Invitation(
        id: invitationId,
        uniqueCode: uniqueCode,
        expirationDate: DateTime.now().add(const Duration(days: 1)),
        email: email);

    await invitationRef.set(invitation.toJson());

    return invitationId;
  }

  Future<String?> createInvitationWithCodeAndDate(
      {required String email,
      required String uniqueCode,
      required DateTime expirationDate}) async {
    UserModel? user = await authService.getCurrentUser();
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    if (user.role != UserRole.ADMIN) {
      throw Exception("You do not have a permission to create invitation");
    }

    DocumentReference invitationRef =
        _firestore.collection('invitations').doc();

    String invitationId = invitationRef.id;

    String uniqueCode = Functions.generateUniqueCode();

    Invitation invitation = Invitation(
        id: invitationId,
        uniqueCode: uniqueCode,
        expirationDate: expirationDate,
        email: email);

    await invitationRef.set(invitation.toJson());

    return invitationId;
  }

  Future<List<Invitation>> getAllInvitations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('invitations').get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Invitation> invitations = querySnapshot.docs
        .map((doc) => Invitation.fromJson(doc.data() as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.expirationDate.compareTo(a.expirationDate));

    invitations = invitations.take(15).toList();

    return invitations;
  }

  Future<Invitation?> findInvitationByUniqueCode(String uniqueCode) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('invitations')
          .where('uniqueCode', isEqualTo: uniqueCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return Invitation.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<Invitation?> findInvitationById(String id) async {
    try {
      DocumentSnapshot invitationDoc =
          await _firestore.collection('invitations').doc(id).get();
      if (!invitationDoc.exists) {
        throw Exception("Invitation not found.");
      }
      return Invitation.fromJson(invitationDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<bool> acceptInvitation(String uniqueCode) async {
    try {
      final querySnapshot = await _firestore
          .collection('invitations')
          .where('uniqueCode', isEqualTo: uniqueCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Invitation not found.");
      }

      final invitationDoc = querySnapshot.docs.first;
      final invitation = Invitation.fromJson(invitationDoc.data());

      if (invitation.expirationDate.isBefore(DateTime.now())) {
        throw Exception("Invitation has expired.");
      }

      if (invitation.isAccepted == true) {
        throw Exception("Invitation has already been accepted.");
      }
      await invitationDoc.reference.update({'isAccepted': true});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateRegistrationCode(String email, String uniqueCode) async {
    Invitation? invitation = await findInvitationByUniqueCode(uniqueCode);

    if (invitation == null) {
      throw Exception("Invitation code does not exist.");
    }
    if (invitation.email == email && invitation.isAccepted == true) {
      throw Exception("Invitation already accepted");
    }
    if (invitation.email == email && invitation.getStatus() == "Expired") {
      throw Exception("Invitation expired");
    }

    if (invitation.email == email &&
        invitation.getStatus() == "Pending" &&
        !invitation.isAccepted) {
      return true;
    } else {
      throw Exception("Invalid invitation code");
    }
  }
}
