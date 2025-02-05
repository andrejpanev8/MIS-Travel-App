import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> findUserByEmailOrPhone({
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
}
