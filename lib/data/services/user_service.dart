import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/models/user.dart';

import '../enums/user_role.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkUserExistsByEmailOrPhone({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      QuerySnapshot emailQuerySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailQuerySnapshot.docs.isNotEmpty) {
        return true;
      }

      QuerySnapshot phoneQuerySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      return phoneQuerySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
      final userQuerySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuerySnapshot.docs.isEmpty) {
        throw Exception("User not found.");
      }

      final userDoc = userQuerySnapshot.docs.first;
      return userDoc.data();
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
  }

  Future<List<UserModel>> getAllUsersByRole(
      {required UserRole userRole}) async {
    try {
      QuerySnapshot emailQuerySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: userRole.index)
          .get();

      List<UserModel> users = emailQuerySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateUserRole(String userId, UserRole newRole) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'role': newRole.index});
      return true;
    } catch (e) {
      return false;
    }
  }
}
