import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/invitation.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../../utils/functions.dart';
import '../models/user.dart';

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

  Future<List<Invitation>> getAllInvitations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('invitations').get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Invitation> invitations = querySnapshot.docs.map((doc) {
      return Invitation.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return invitations;
  }

  Future<DocumentSnapshot?> findInvitationByUniqueCode(
      String uniqueCode) async {
    try {
      final querySnapshot = await _firestore
          .collection('invitations')
          .where('uniqueCode', isEqualTo: uniqueCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      return querySnapshot.docs.first;
    } catch (e) {
      return null;
    }
  }

  Future<bool> acceptInvitation(String uniqueCode) async {
    try {
      final invitationDoc = await findInvitationByUniqueCode(uniqueCode);

      if (invitationDoc == null) {
        throw Exception("Invitation not found.");
      }

      final invitationData = invitationDoc.data() as Map<String, dynamic>?;

      if (invitationData == null) {
        throw Exception("Invitation data is invalid.");
      }

      final invitation = Invitation.fromJson(invitationData);

      if (invitation.expirationDate.isBefore(DateTime.now())) {
        throw Exception("Invitation has expired.");
      }

      if (invitation.isAccepted) {
        throw Exception("Invitation has already been accepted.");
      }
      var currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }
      if (currentUser.email != invitation.email) {
        throw Exception("Email is not correct");
      }
      await invitationDoc.reference.update({'isAccepted': true});

      final changeRole = await userService.updateUserRole(
        currentUser.id,
        UserRole.DRIVER,
      );
      return changeRole;
    } catch (e) {
      return false;
    }
  }
}
